from pydantic import BaseModel, field_validator, ConfigDict
from typing import List

class UserPydantic(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: str
    phone: str
    password_hash: str

    model_config = {
        'from_attributes': True
    }
