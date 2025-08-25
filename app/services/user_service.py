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


def get_user_info():
    with session_scope() as session:
        user_db = session.query(User).filter_by(user_id=current_user.user_id).first()
        user = UserPydantic.model_validate(user_db)
    return user


def set_user_info_form(form):
    user = get_user_info()

    form.first_name.data = user.first_name
    form.last_name.data = user.last_name

    return user

