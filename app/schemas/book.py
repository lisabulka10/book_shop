from pydantic import BaseModel
from typing import List, Optional

from .user import UserPydantic


class UserReviewPydantic(BaseModel):
    id: int
    user_id: int
    review_id: int

    user: Optional[UserPydantic] = None

    model_config = {
        'from_attributes': True
    }


class ReviewPydantic(BaseModel):
    id: int
    book_id: int
    rate: int
    text: str

    user_review: Optional[UserReviewPydantic] = None

    model_config = {
        'from_attributes': True
    }


class AuthorPydantic(BaseModel):
    id: int
    name: str

    model_config = {
        'from_attributes': True
    }


class BookPydantic(BaseModel):
    id: int
    author_id: int
    genre_id: int
    title: str
    price: float
    book_cover: str
    description: str
    publishing: str
    year: int
    binding: str

    author: Optional[AuthorPydantic] = None
    reviews: Optional[List[ReviewPydantic]] = None

    model_config = {
        'from_attributes': True
    }


class BookPydanticDB(BaseModel):
    id: int
    author_id: int
    genre_id: int
    title: str
    price: float
    book_cover: str
    description: str
    publishing: str
    year: int
    binding: str

    model_config = {
        'from_attributes': True
    }


class GenrePydantic(BaseModel):
    id: int
    name: str
    section_id: int

    books: List[BookPydantic]

    model_config = {
        'from_attributes': True
    }


class SectionPydantic(BaseModel):
    id: int
    name: str
    genres: List[GenrePydantic]

    model_config = {
        'from_attributes': True
    }
