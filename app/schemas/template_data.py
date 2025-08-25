from _datetime import datetime
from pydantic import BaseModel, field_validator, ConfigDict
from typing import List, Optional

from .book import BookPydantic
from .user import UserPydantic
from .address import ShopPydantic

# можно сделать 2 pydantic для личных адресов и адресов магазинов
class UserAddress(BaseModel):
    country: str
    city: str
    street: str
    house: str
    office: Optional[str] = None
    entrance: Optional[str] = None
    intercom: Optional[str] = None
    floor: Optional[str] = None

    model_config = {
        'from_attributes': True
    }
