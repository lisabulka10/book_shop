import uuid
import re
import requests

from flask import Blueprint, render_template, flash, redirect, url_for, request, jsonify, make_response
from flask_login import current_user, login_required
from sqlalchemy.orm import selectinload

from ..database import session_scope
from ..models.user import User
from ..models.book import Book
from ..models.order import CartItem, Cart, Order, OrderItem, DeliveryType, PayMethod, Status, \
    Delivery
from ..models.address import Shop, Address, AddressAddition, UserAddress
from ..schemas.book import SectionPydantic, GenrePydantic, BookPydantic
from ..schemas.order import CartItemPydantic, OrderPydantic, OrderItemPydantic, CartPydantic
from ..schemas.address import ShopPydantic, AddressPydantic, AddressAdditionPydantic, UserAddressPydantic
from ..schemas.user import UserPydantic
from ..forms import AddressFrom, Country, OrderInfoForm

from .main_service import get_catalog, prepare_data_template, get_book


def find_cart(session, user_id=None, session_id=None):
    if user_id:
        return session.query(Cart).filter_by(user_id=user_id).first
    if session_id:
        return session.query(Cart).filter_by(session_id=session_id).first
    return None


def get_or_create_cart():
    with session_scope() as session:
        if current_user.is_authenticated:
            cart = session.query(Cart).filter_by(user_id=current_user.user_id).first()
            if not cart:
                cart = Cart(user_id=current_user.user_id)
                session.add(cart)
                session.flush()
            return cart  # Возвращаем SQLAlchemy-модель, а не Pydantic

        # Гость
        session_id = request.cookies.get("cart_id")
        if not session_id:
            session_id = str(uuid.uuid4())
            cart = Cart(session_id=session_id)
            session.add(cart)
            session.flush()
            return cart, session_id

        cart = session.query(Cart).filter_by(session_id=session_id).first()
        if not cart:
            cart = Cart(session_id=session_id)
            session.add(cart)
            session.flush()
        return cart


def get_cart():
    cart_obj = get_or_create_cart()
    if isinstance(cart_obj, tuple):
        cart, session_id = cart_obj
        resp_needed = True
    else:
        cart = cart_obj
        session_id = None
        resp_needed = False
    return cart, session_id, resp_needed


def set_cart_form(form):
    cart_item = get_cart_items()
    if not form.items:
        for item in cart_item:
            form.items.append_entry({
                'book_id': item.book.id,
                'count': item.count,
                'selected': True
            })


def get_cart_item_book(book_id):
    #cart, _, _, = get_cart()
    with session_scope() as session:
        item = session.query(CartItem).filter_by(cart_id=cart.id, book_id=book_id).first()
        if item:
            cart_item = CartItemPydantic.model_validate(item)
        else:
            return None

    return cart_item


def increase_cart_item_count(item_id):
    cart, _, _, = get_cart()
    with session_scope() as session:
        item = session.query(CartItem).filter_by(cart_id=cart.id, id=item_id).first()
        item.count += 1
        print(f'count cart_item + 1 = {item.count}')


def get_total_count_cart_items():
    cart, _, _, = get_cart()
    with session_scope() as session:
        total_items = session.query(CartItem).filter_by(cart_id=cart.id).count()
    return total_items


def get_cart_total_amount():
    cart_items = get_cart_items()
    return sum(item.count * item.book.price for item in cart_items)


def add_cart_item_db(book_id):
    cart, _, _, = get_cart()
    with session_scope() as session:
        session.add(CartItem(cart_id=cart.id, book_id=book_id, count=1))
        print('cart item add success')


def get_cart_items():
    cart, _, _, = get_cart()
    with session_scope() as session:
        items = (
            session.query(CartItem)
            .filter_by(cart_id=cart.id)
            .options(selectinload(CartItem.cart)
                     .options(selectinload(Cart.user)))
            .options(selectinload(CartItem.book))
            .all()
        )

        cart_items = [CartItemPydantic.model_validate(item) for item in items]

    return cart_items


def delete_cart_items_all():
    cart, _, _, = get_cart()
    with session_scope() as session:
        cart_items = session.query(CartItem).filter_by(cart_id=cart.id).all()
        for item in cart_items:
            session.delete(item)


def delete_cart_item(item_id):
    cart, _, _, = get_cart()
    with session_scope() as session:
        cart_item = session.query(CartItem).filter_by(cart_id=cart.id, id=item_id).first()
        session.delete(cart_item)
        print(cart_item)


def merge_carts(session_id):
    with session_scope() as session:
        user_cart = session.query(Cart).filter_by(user_id=current_user.user_id).first()
        guest_cart = session.query(Cart).filter_by(session_id=session_id).first()

        if not guest_cart:
            return user_cart

        if not user_cart:
            guest_cart.user_id = current_user.user_id
            guest_cart.session_id = None
            return guest_cart

        for guest_item in guest_cart.cart_items:
            existing_item = (
                session.query(CartItem)
                .filter_by(cart_id=user_cart.id, book_id=guest_item.book_id)
                .first()
            )
            if existing_item:
                existing_item.count += guest_item.count
                session.delete(guest_item)
            else:
                guest_item.card_id = user_cart.id

        session.delete(guest_cart)

        return user_cart
