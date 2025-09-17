from pydantic import BaseModel


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
