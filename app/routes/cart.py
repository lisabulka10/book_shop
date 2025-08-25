import datetime
import re
import requests

from flask import Blueprint, render_template, flash, redirect, url_for, request, jsonify, make_response
from flask_login import current_user, login_required
from sqlalchemy.orm import selectinload
from sqlalchemy import select
from pydantic import TypeAdapter
import random

from ..database import session_scope
from ..models.user import User
from ..models.book import Book
from ..models.order import CartItem, Order, OrderItem, DeliveryType, PayMethod, Status, \
    Delivery
from ..models.address import Shop, Address, AddressAddition, UserAddress
from ..schemas.book import SectionPydantic, GenrePydantic, BookPydantic
from ..schemas.order import CartItemPydantic, OrderPydantic, OrderItemPydantic
from ..schemas.address import ShopPydantic, AddressPydantic, AddressAdditionPydantic, UserAddressPydantic
from ..schemas.user import UserPydantic
from ..forms import AddressFrom, Country, OrderInfoForm, CartForm

from ..services.main_service import get_catalog, prepare_data_template, get_book
from ..services.order_service import load_form_choices, shop_is_exist, add_user_address_db, \
    get_address_model, add_address_db, get_user_address, load_form_address_choices, \
    set_addition_form, get_addition, get_addition_model, add_addition_db, add_order_db, add_order_items, \
    add_delivery_db, get_orders_all, get_order
from ..services.user_service import get_user_info, set_user_info_form
from ..services.cart_service import delete_cart_item, get_cart_items, get_total_count_cart_items, \
    increase_cart_item_count, get_cart_item_book, add_cart_item_db, delete_cart_items_all, get_cart

cart_bp = Blueprint('cart', __name__)


@cart_bp.route('/cart/add', methods=['POST'])
def add_to_cart():
    data = request.json
    book_id = data.get('book_id')

    add_cart_item_db(book_id)
    total_items = len(get_cart_items())

    # Проверяем, нужно ли устанавливать cookie
    _, session_id, resp_needed = get_cart()
    if resp_needed:
        resp = make_response(jsonify({
            "message": "Книга успешно добавлена",
            "cart_count": total_items
        }))
        resp.set_cookie("cart_id", session_id, max_age=30 * 24 * 60 * 60)
        return resp

    return jsonify({
        "message": "Книга успешно добавлена",
        "cart_count": total_items
    })


@cart_bp.route('/cart', methods=['POST', 'GET'])
def cart():
    _, session_id, resp_needed = get_cart()
    if resp_needed:
        resp = make_response(render_template("cart.html", cart_items=get_cart_items()))
        resp.set_cookie("cart_id", session_id, max_age=30 * 24 * 60 * 60)
        return resp

    form = CartForm()
    if form.validate_on_submit():
        selected_items = [item for item in form.items if item.selected.data]

    return render_template('order/cart.html', cart_items=get_cart_items())


@cart_bp.route('/delete')
def delete():
    delete_cart_items_all()
    return redirect(url_for('order.cart'))


@cart_bp.route('/delete/<int:item_id>')
def delete_item(item_id):
    delete_cart_item(item_id)
    return redirect(url_for('cart.cart'))
