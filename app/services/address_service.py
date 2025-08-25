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


def add_addition_db(data):
    addition = AddressAddition(**data)
    with session_scope() as session:
        session.add(AddressAddition(addition))


def set_addition_form(form, address_id):
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


def get_addition_from_form(form):
    #учесть то что адрес может быть и магазином
    office = form.office.data if form.office.data else None
    entrance = form.entrance.data if form.entrance.data else None
    intercom = form.intercom.data if form.intercom.data else None
    floor = form.floor.data if form.floor.data else None
    phone = form.phone.data
    first_name = form.first_name.data
    last_name = form.last_name.data
    address_id = form.address.data

    return {
        'office': office,
        'entrance': entrance,
        'intercom': intercom,
        'floor': floor,
        'phone': phone,
        'first_name': first_name,
        'last_name': last_name,
        'address_id': address_id
    }





def add_address_db(form):
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
    with session_scope() as session:
        session.add(address)
        session.flush()
        address_id = address.id
    print(f'add address, address_id = {address_id}')
    return address_id


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


def add_user_address_db(address_id):
    with session_scope() as session:
        session.add(UserAddress(
            address_id=address_id,
            user_id=current_user.user_id
        ))



def get_addition(form):
    address_id = form.address.data
    if not address_id:
        return False
    with session_scope() as session:
        addition_db = session.query(AddressAddition).filter_by(address_id=address_id).first()
        if addition_db:
            addition = AddressAdditionPydantic.model_validate(addition_db)
        else:
            return False

    if addition.office:
        form.office.data = addition.office

    if addition.entrance:
        form.entrance.data = addition.entrance

    if addition.intercom:
        form.intercom.data = addition.intercom

    if addition.floor:
        form.floor.data = addition.floor

    return addition


def get_user_info(form):
    print('get user info in')
    with session_scope() as session:
        user_db = session.query(User).filter_by(user_id=current_user.user_id).first()
        user = UserPydantic.model_validate(user_db)

    form.first_name.data = user.first_name
    form.last_name.data = user.last_name

    print('get user info out')
    return user


def add_addition_db(form):
    print('add addition in')
    address_id = form.address.data
    with session_scope() as session:
        shops_db = session.query(Shop).filter_by(address_id=address_id).first()
        if shops_db:
            return False

        office = form.office.data if form.office.data else None
        entrance = form.entrance.data if form.entrance.data else None
        intercom = form.intercom.data if form.intercom.data else None
        floor = form.floor.data if form.floor.data else None

        session.add(AddressAddition(
            office=office,
            entrance=entrance,
            intercom=intercom,
            floor=floor,
            phone=form.phone.data,
            first_name=form.first_name.data,
            last_name=form.last_name.data,
            address_id=address_id
        ))

    print('add addition out')
    return True
    # phone = form.cleaned_phone
    # first_name = form.first_name.data
    # last_name = form.last_name.data


def add_order_db(form):
    print('add order in')
    pay_method_name = form.pay_method.data
    with session_scope() as session:
        order = Order(
            user_id=current_user.user_id,
            date=datetime.datetime.now(),
            status=Status.PROCESSING,
            pay_method=PayMethod[pay_method_name]
        )
        session.add(order)
        session.flush()
        order_id = order.id

    print(f'add order out, order_id = {order_id}')
    return order_id


def add_order_items(order_id):
    print('add order items in')
    with session_scope() as session:
        items = session.query(CartItem).filter_by(user_id=current_user.user_id).all()
        cart_items = [CartItemPydantic.model_validate(item) for item in items]
        for item in cart_items:
            session.add(OrderItem(
                book_id=item.book_id,
                order_id=order_id,
                count=item.count
            ))
            session.delete(item)

    print('add order items out')


def add_delivery(order_id, address_id, price=0):
    print('add add delivery in')
    address = get_user_address(address_id)
    if address.shop:
        delivery_type = DeliveryType.PICKUP
    else:
        delivery_type = DeliveryType.COURIER
    with session_scope() as session:
        session.add(Delivery(
            order_id=order_id,
            delivery_type=delivery_type,
            address_id=address_id,
            price=price
        ))

    print('add add delivery in')

