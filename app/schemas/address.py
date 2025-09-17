from pydantic import BaseModel
from typing import Optional

from .user import UserPydantic


class AddressPydantic(BaseModel):
    id: int
    country: str
    city: str
    street: str
    house: str

    model_config = {
        'from_attributes': True
    }


class AddressAdditionPydantic(BaseModel):
    id: int
    address_id: int
    office: str
    entrance: str
    intercom: str
    floor: str
    phone: str
    first_name: str
    last_name: str

    address: Optional[AddressPydantic]

    model_config = {
        'from_attributes': True
    }


class ShopPydantic(BaseModel):
    id: int
    work_time: str
    lat: float
    lon: float
    address_id: int

    address: Optional[AddressPydantic] = None

    model_config = {
        'from_attributes': True
    }


class ShopPydanticCreate(BaseModel):
    id: int
    work_time: str
    lat: float
    lon: float
    address_id: int

    model_config = {
        'from_attributes': True
    }


class UserAddressPydantic(BaseModel):
    id: int
    address_id: int
    user_id: int

    address: AddressPydantic
    user: UserPydantic
    shop: Optional[bool] = False

    model_config = {
        'from_attributes': True
    }
