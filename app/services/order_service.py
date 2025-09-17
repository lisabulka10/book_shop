import datetime

from flask import flash, jsonify
from flask_login import current_user
from sqlalchemy.orm import selectinload

from ..database import session_scope

from ..models.book import Book
from ..models.order import CartItem, Order, OrderItem, DeliveryType, PayMethod, Status, Delivery
from ..models.address import Shop, Address, AddressAddition, UserAddress

from ..schemas.order import OrderPydantic
from ..schemas.address import ShopPydantic, AddressAdditionPydantic, UserAddressPydantic

from .cart_service import get_cart_items, get_cart


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
        if is_shop(address_id):
            user_address_db = session.query(UserAddress).filter_by(user_id=current_user.user_id,
                                                                   address_id=address_id).first()
            if user_address_db:
                return
        session.add(UserAddress(
            address_id=address_id,
            user_id=current_user.user_id
        ))


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


def check_address(address):
    with session_scope() as session:
        address_db = session.query(Address).filter_by(
            country=address.country,
            city=address.city,
            street=address.street,
            house=address.house
        ).first()
        if address_db:
            return True
        else:
            return False


def add_address_db(address):
    if not check_address(address):
        with session_scope() as session:
            session.add(address)
            session.flush()
            address_id = address.id
            session.add(UserAddress(user_id=current_user.user_id, address_id=address_id))

        return address_id


def add_address(form):
    delivery_type = DeliveryType[form.delivery_type.data]
    if delivery_type == DeliveryType.PICKUP:
        shop_address_id = form.shops.data
        if not shop_is_exist(shop_address_id):
            flash('Выберите магазин для самовывоза', 'danger')
            return False
        add_user_address_db(shop_address_id)
    else:
        address_model = get_address_model(form)
        add_address_db(address_model)

    return True


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
                return address

        return user_addresses_pydantic


def load_form_address_choices(form):
    addresses = get_user_address()
    form.address.choices = [
        (address.address_id, f'{address.address.city}, {address.address.street}, {address.address.house}') for address
        in addresses
    ]


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

    return order_id


def add_addition_db(addition):
    with session_scope() as session:
        session.add(addition)


def update_or_create_addition(form):
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

    with session_scope() as session:
        addition = session.query(AddressAddition).filter_by(address_id=address_id).first()
        if addition:
            addition.office = office
            addition.entrance = entrance
            addition.intercom = intercom
            addition.floor = floor
            addition.first_name = first_name
            addition.last_name = last_name
        else:
            add_addition_db(AddressAddition(
                office=office,
                entrance=entrance,
                intercom=intercom,
                floor=floor,
                phone=phone,
                first_name=first_name,
                last_name=last_name,
                address_id=address_id
            ))


def add_delivery_db(delivery):
    with session_scope() as session:
        session.add(delivery)


def add_order_items(order_id):
    cart = get_cart(False)
    if not cart:
        raise ValueError('Корзины не существует')

    with session_scope() as session:
        cart_items = session.query(CartItem).filter_by(cart_id=cart.id, selected=True).all()
        for item in cart_items:
            session.add(OrderItem(
                book_id=item.book_id,
                order_id=order_id,
                count=item.count
            ))
            session.delete(item)


def create_order_db(form):
    try:
        order_id = add_order_db(form.pay_method.data)
        if is_shop(form.address.data):
            delivery = DeliveryType.PICKUP
        else:
            delivery = DeliveryType.COURIER
            update_or_create_addition(form)

        delivery_db = Delivery(
            order_id=order_id,
            delivery_type=delivery,
            address_id=form.address.data,
            price=0)
        add_delivery_db(delivery_db)

        add_order_items(order_id)

    except Exception as e:
        print(e)
        return False

    return True


def get_shop_list(city_name):
    with session_scope() as session:
        shops_db = session.query(Shop).options(selectinload(Shop.address)).all()
        shops_pydantic = [ShopPydantic.model_validate(shop) for shop in shops_db]

        city_shop = [shop for shop in shops_pydantic if shop.address.city == city_name]
        shops = [ShopPydantic.model_validate(shop).model_dump() for shop in city_shop]
        return shops


def delete_address_db(address_id):
    with session_scope() as session:
        address = session.query(UserAddress).filter_by(user_id=current_user.user_id, address_id=address_id).first()
        session.delete(address)


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

    return order


def address_details_post_result(delivery_type, address_id):
    if delivery_type == DeliveryType.PICKUP.value:
        return jsonify({
            "message": "Дополнительная информация не требуется",
            "shop": True
        })
    else:
        addition = get_addition(address_id)
        if not addition:
            return jsonify({
                "message": "Информация о деталях отсутствует",
                "shop": False,
                "office": "",
                "entrance": "",
                "intercom": "",
                "floor": ""
            })

        return jsonify({
            "message": "Информация о деталях присутствует",
            "shop": False,
            "office": addition.office,
            "entrance": addition.entrance,
            "intercom": addition.intercom,
            "floor": addition.floor
        })
