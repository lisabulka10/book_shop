import datetime
import re
import requests

from flask import Blueprint, render_template, flash, redirect, url_for, request, jsonify
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
    get_address_model, add_address_db, get_user_address, get_cart_items, load_form_address_choices,\
    set_addition_form, get_addition, get_addition_model, add_addition_db, add_order_db, add_order_items, \
    add_delivery_db, get_orders_all, get_order
from ..services.user_service import get_user_info, set_user_info_form
from ..services.cart_service import delete_cart_item, get_cart_item_book, increase_cart_item_count, \
    add_cart_item_db, delete_cart_items_all, get_total_count_cart_items, get_cart_total_amount

order_bp = Blueprint('order', __name__)


@order_bp.route('/map', methods=['POST', 'GET'])
@login_required
def get_address():
    form = AddressFrom()
    load_form_choices(form)

    if form.validate_on_submit():
        delivery_type = DeliveryType[form.delivery_type.data]
        if delivery_type == DeliveryType.PICKUP:
            shop_address_id = form.shops.data
            if not shop_is_exist(shop_address_id):
                flash('Выберите магазин для самовывоза', 'danger')
                return redirect(url_for('order.get_address'))
            add_user_address_db(shop_address_id)
        else:
            address_model = get_address_model(form)
            address_id = add_address_db(address_model)
            add_user_address_db(address_id)
        return redirect(url_for('order.create_order'))
    else:
        print(form.errors)
    return render_template('order/map.html', form=form)


@order_bp.route('/order', methods=['POST', 'GET'])
@login_required
def create_order():
    form = OrderInfoForm()

    load_form_address_choices(form)
    set_addition_form(form)
    set_user_info_form(form)
    template_data = prepare_data_template(
        #cart_items=cart_items,
        user_addresses=get_user_address(),
        count_items=get_total_count_cart_items(),
        amount=get_cart_total_amount(),
        PayMethod=PayMethod,
        DeliveryType=DeliveryType,
        form=form
    )
    print(request.method)
    print(form.data)
    print(form.is_submitted())

    if form.validate_on_submit():
        try:
            order_id = add_order_db(form.pay_method.data)

            addition = get_addition_model(form)
            print(f'ADDITION {addition}')
            if addition:
                delivery = DeliveryType.COURIER
                add_addition_db(addition)
            else:
                delivery = DeliveryType.PICKUP

            print(f'DELIVERY {delivery}')
            delivery_db = Delivery(
                order_id=order_id,
                delivery_type=delivery,
                address_id=form.address.data,
                price=0)
            add_delivery_db(delivery_db)

            add_order_items(order_id)

        except Exception as e:
            print(e)
        return redirect(url_for('order.get_order_list'))
    else:
        flash(form.errors, 'danger')
        print(form.errors)

    return render_template('order/order.html', **template_data)


@order_bp.route('/shops/<city_name>', methods=['GET'])
@login_required
def get_shops(city_name):
    with session_scope() as session:
        shops_db = session.query(Shop).options(selectinload(Shop.address)).all()
        shops_pydantic = [ShopPydantic.model_validate(shop) for shop in shops_db]

        city_shop = [shop for shop in shops_pydantic if shop.address.city == city_name]
        shops = [ShopPydantic.model_validate(shop).model_dump() for shop in city_shop]
    print(shops)
    return jsonify(shops)


@order_bp.route('/make_order', methods=['GET', 'POST'])
@login_required
def make_order():
    return redirect(url_for('order.get_orders_list'))


@order_bp.route('/delete/address/<int:address_id>')
@login_required
def delete_address(address_id):
    with session_scope() as session:
        address = session.query(Address).get(address_id)
        session.delete(address)

    return redirect(url_for('order.create_order'))


@order_bp.route('/order_list', methods=['GET'])
@login_required
def get_order_list():
    template_data = prepare_data_template(catalog=get_catalog(), orders=get_orders_all())
    return render_template('order/order_list.html', **template_data)


@order_bp.route('/order/<int:order_id>')
@login_required
def order(order_id):
    template_data = prepare_data_template(order=get_order(order_id), catalog=get_catalog())
    return render_template('order/order_info.html', **template_data)


@order_bp.route('/geoip')
def geoip():
    try:
        r = requests.get("https://ipapi.co/json")
        return jsonify(r.json())
    except:
        return jsonify({"country_code": "RU"})



