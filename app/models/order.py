from . import Base
from sqlalchemy import Integer, String, Column, ForeignKey, Enum, Date, Float
from sqlalchemy.orm import relationship

from enum import Enum as EnumClass


class Status(EnumClass):
    PROCESSING = 'Обрабатывается'
    WORK = 'В работе'
    DONE = 'Заказ готов к выдаче'


class DeliveryType(EnumClass):
    COURIER = 'Курьер'
    PICKUP = 'Самовывоз'


class PayMethod(EnumClass):
    SBP = 'СБП'
    CARD = 'Картой'
    RECEIPT = 'При получении'


class Order(Base):
    __tablename__ = 'orders'

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.user_id'))
    date = Column(Date)
    status = Column(Enum(Status))
    pay_method = Column(Enum(PayMethod))
    amount = Column(Float)

    user = relationship('User', back_populates='orders', uselist=False)
    order_items = relationship('OrderItem', back_populates='order', cascade="all, delete")
    delivery = relationship('Delivery', back_populates='order', cascade="all, delete", uselist=False)


class Delivery(Base):
    __tablename__ = 'deliveries'

    id = Column(Integer, primary_key=True)
    order_id = Column(Integer, ForeignKey('orders.id'))
    delivery_type = Column(Enum(DeliveryType))
    address_id = Column(Integer, ForeignKey('addresses.id'), nullable=True)
    price = Column(Float, nullable=True)

    address = relationship('Address', back_populates='delivery')
    order = relationship('Order', back_populates='delivery', uselist=False)


class OrderItem(Base):
    __tablename__ = 'order_items'

    id = Column(Integer, primary_key=True)
    book_id = Column(Integer, ForeignKey('books.id'))
    order_id = Column(Integer, ForeignKey('orders.id'))
    count = Column(Integer)

    book = relationship('Book', back_populates='order_items', uselist=False)
    order = relationship('Order', back_populates='order_items', uselist=False)


class CartItem(Base):
    __tablename__ = 'cart_items'

    id = Column(Integer, primary_key=True)
    cart_id = Column(Integer, ForeignKey('carts.id'))
    book_id = Column(Integer, ForeignKey('books.id'))
    count = Column(Integer)

    book = relationship('Book', back_populates='cart_items', uselist=False)
    cart = relationship('Cart', back_populates='cart_items', uselist=False)


class Cart(Base):
    __tablename__ = 'carts'

    id = Column(Integer, primary_key=True)
    session_id = Column(String, nullable=True, unique=True)
    user_id = Column(Integer, ForeignKey('users.user_id'), nullable=True)

    user = relationship('User', back_populates='cart', uselist=False)
    cart_items = relationship('CartItem', back_populates='cart')
