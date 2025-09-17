from . import Base
from sqlalchemy import Integer, String, Column, ForeignKey, Float
from sqlalchemy.orm import relationship


class Address(Base):
    __tablename__ = 'addresses'

    id = Column(Integer, primary_key=True)
    country = Column(String(80))
    city = Column(String(250))
    street = Column(String(250))
    house = Column(String(10))

    shop = relationship('Shop', back_populates='address', cascade="all, delete")
    addition = relationship('AddressAddition', back_populates='address', cascade="all, delete")
    user_address = relationship('UserAddress', back_populates='address', cascade="all, delete")
    delivery = relationship('Delivery', back_populates='address')


class AddressAddition(Base):
    __tablename__ = 'additions'

    id = Column(Integer, primary_key=True)
    address_id = Column(Integer, ForeignKey('addresses.id'))
    office = Column(String(10))
    entrance = Column(String(10))
    intercom = Column(String(10))
    floor = Column(String(10))
    phone = Column(String(15))
    first_name = Column(String(length=80))
    last_name = Column(String(length=80))

    address = relationship('Address', back_populates='addition')


class Shop(Base):
    __tablename__ = 'shops'

    id = Column(Integer, primary_key=True)
    work_time = Column(String(30))
    lat = Column(Float)
    lon = Column(Float)
    address_id = Column(Integer, ForeignKey('addresses.id'))

    address = relationship('Address', back_populates='shop')


class UserAddress(Base):
    __tablename__ = 'user_addresses'

    id = Column(Integer, primary_key=True)
    address_id = Column(Integer, ForeignKey('addresses.id'))
    user_id = Column(Integer, ForeignKey('users.user_id'))

    address = relationship('Address', back_populates='user_address')
    user = relationship('User', back_populates='user_address')
