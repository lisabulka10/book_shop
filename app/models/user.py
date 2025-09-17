
from flask_login import UserMixin

from sqlalchemy import Integer, String, Column, Boolean
from sqlalchemy.orm import relationship

from . import Base


class User(Base, UserMixin):
    __tablename__ = 'users'

    user_id = Column(Integer, primary_key=True)
    first_name = Column(String(length=80))
    last_name = Column(String(length=80))
    email = Column(String(length=120), unique=True)
    phone = Column(String, nullable=False)
    password_hash = Column(String(length=256))
    is_verified = Column(Boolean, default=False)

    user_review = relationship('UserReview', back_populates='user', cascade="all, delete")
    orders = relationship('Order', back_populates='user', cascade="all, delete")
    cart = relationship('Cart', back_populates='user', cascade="all, delete")
    user_address = relationship('UserAddress', back_populates='user', cascade="all, delete")

    def get_id(self):
        return self.user_id



