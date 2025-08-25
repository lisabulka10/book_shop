from _datetime import datetime
from pydantic import BaseModel, field_validator, ConfigDict
from typing import List, Optional

from .book import BookPydantic
from .user import UserPydantic
from .address import AddressPydantic
from ..models.order import Status, DeliveryType, PayMethod


class OrderItemPydantic(BaseModel):
    id: int
    book_id: int
    count: int
    order_id: int

    book: Optional[BookPydantic] = None

    model_config = {
        'from_attributes': True
    }


class DeliveryPydantic(BaseModel):
    id: int
    order_id: int
    delivery_type: DeliveryType
    address_id: int
    price: float

    address: Optional[AddressPydantic] = None

    model_config = {
        'from_attributes': True
    }


class OrderPydantic(BaseModel):
    id: int
    user_id: int
    date: datetime
    status: Status
    pay_method: PayMethod
    amount: float

    user: UserPydantic
    order_items: Optional[List[OrderItemPydantic]] = None
    delivery: Optional[DeliveryPydantic] = None

    model_config = {
        'from_attributes': True
    }


class CartPydantic(BaseModel):
    id: int
    session_id: Optional[str] = None
    user_id: Optional[int] = None

    user: Optional[UserPydantic] = None

    model_config = {
        'from_attributes': True
    }


class CartItemPydantic(BaseModel):
    id: int
    book_id: int
    cart_id: int
    count: int

    book: Optional[BookPydantic] = None
    cart: Optional[CartPydantic] = None

    model_config = {
        'from_attributes': True
    }

