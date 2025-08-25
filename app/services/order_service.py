import datetime
import re
import requests

from flask import Blueprint, render_template, flash, redirect, url_for, request, jsonify
from flask_login import current_user, login_required
from sqlalchemy.orm import selectinload

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
from ..forms import AddressFrom, Country, OrderInfoForm

from .main_service import get_catalog, prepare_data_template, get_book
from .cart_service import get_cart_items


def add_order_db(pay_method_name):
    cart_items = get_cart_items()
    amount = sum([item.count * item.book.price for item in cart_items])
    order = Order(
        user_id=current_user.user_id,
        date=datetime.datetime.now(),
        status=Status.PROCESSING,
        pay_method=PayMethod[pay_method_name],
        amount=amount
    )
    with session_scope() as session:
        session.add(order)
        session.flush()
        order_id = order.id
        print('order add success')

    return order_id


def add_order_items(order_id):
    with session_scope() as session:
        cart_items = session.query(CartItem).filter_by(user_id=current_user.user_id).all()
        for item in cart_items:
            session.add(OrderItem(
                book_id=item.book_id,
                order_id=order_id,
                count=item.count
            ))
            session.delete(item)

        print('order items add success')
        print('cart item delete success')


def get_orders_all():
    with session_scope() as session:
        orders_db = (
            session.query(Order)
            .filter_by(user_id=current_user.user_id)
            .options(selectinload(Order.order_items)
                     .options(selectinload(OrderItem.book)))
            .all()
        )
        orders = [OrderPydantic.model_validate(item) for item in orders_db]

    return orders


def get_order(order_id):
    with session_scope() as session:
        order_db = (
            session.query(Order)
            .filter_by(id=order_id)
            .options(selectinload(Order.delivery))
            .options(selectinload(Order.order_items)
                     .options(selectinload(OrderItem.book)
                              .options(selectinload(Book.author))))
            .first()
        )
        order = OrderPydantic.model_validate(order_db)
        print(f'order is {order}')

    return order


def add_delivery_db(delivery):
    with session_scope() as session:
        session.add(delivery)
        print('delivery add success')


def get_addition(address_id):
    if not address_id:
        return False
    with session_scope() as session:
        addition_db = session.query(AddressAddition).filter_by(address_id=address_id).first()
        if addition_db:
            addition = AddressAdditionPydantic.model_validate(addition_db)
        else:
            return False
    return addition


def add_addition_db(addition):
    with session_scope() as session:
        session.add(addition)


def set_addition_form(form):
    address_id = form.address.data
    addition = get_addition(address_id)
    if not addition:
        return
    if addition.office:
        form.office.data = addition.office

    if addition.entrance:
        form.entrance.data = addition.entrance

    if addition.intercom:
        form.intercom.data = addition.intercom

    if addition.floor:
        form.floor.data = addition.floor

    return addition


def get_addition_model(form):
    # учесть то что адрес может быть и магазином
    office = form.office.data if form.office.data else None
    entrance = form.entrance.data if form.entrance.data else None
    intercom = form.intercom.data if form.intercom.data else None
    floor = form.floor.data if form.floor.data else None
    phone = form.phone.data
    first_name = form.first_name.data
    last_name = form.last_name.data
    address_id = form.address.data

    if is_shop(address_id):
        return False

    return AddressAddition(
        office=office,
        entrance=entrance,
        intercom=intercom,
        floor=floor,
        phone=phone,
        first_name=first_name,
        last_name=last_name,
        address_id=address_id
    )


def get_address_model(form):
    address_str = form.address.data.split(', ')
    if len(address_str) == 3:
        street = address_str[1]
        house = address_str[2]
    elif len(address_str) == 2:
        street = address_str[1]
        house = ''
    else:
        raise ValueError('Неправильный адрес')
    address = Address(
        country=form.country.data,
        city=form.city.data,
        street=street,
        house=house,
    )
    return address


def add_address_db(address):
    with session_scope() as session:
        session.add(address)
        session.flush()
        address_id = address.id
    print(f'add address, address_id = {address_id}')
    return address_id


def load_form_address_choices(form):
    addresses = get_user_address()
    form.address.choices = [
        (address.address_id, f'{address.address.city}, {address.address.street}, {address.address.house}') for address
        in addresses
    ]


def load_form_choices(form):
    with session_scope() as session:
        shops_db = session.query(Shop).options(selectinload(Shop.address)).all()
        shops_pydantic = [ShopPydantic.model_validate(shop) for shop in shops_db]

    cities = list(set([shop.address.city for shop in shops_pydantic]))
    form.city_shop.choices = [(city_name, city_name) for city_name in cities]

    if cities:
        first_city = cities[0]
        city_shops = [shop for shop in shops_pydantic if shop.address.city == first_city]
        form.shops.choices = [(0, '- Выберите магазин - ')] + \
                             [(shop.address_id, f'{shop.address.street}, {shop.address.house}') for shop in city_shops]


def shop_is_exist(shop_address_id):
    with session_scope() as session:
        shop_address = session.query(Address).get(shop_address_id)
        if not shop_address:
            return False
    return True


def is_shop(address_id):
    with session_scope() as session:
        shop = session.query(Shop).filter_by(address_id=address_id).first()
        if shop:
            return True
        else:
            return False


def add_user_address_db(address_id):
    with session_scope() as session:
        session.add(UserAddress(
            address_id=address_id,
            user_id=current_user.user_id
        ))


def get_user_address(address_id=None):
    with session_scope() as session:
        user_addresses_db = (
            session.query(UserAddress)
            .options(selectinload(UserAddress.address))
            .filter_by(user_id=current_user.user_id).all()
        )
        user_addresses_pydantic = [UserAddressPydantic.model_validate(address) for address in user_addresses_db]
        for address in user_addresses_pydantic:
            shop = session.query(Shop).filter_by(address_id=address.address_id).first()
            if shop:
                address.shop = True

            if (address_id is not None) and (address.address_id == int(address_id)):
                print('get address')
                return address
        print(f'no address list. address id {address_id}')
        print(user_addresses_pydantic)
        return user_addresses_pydantic
