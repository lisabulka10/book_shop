from pydantic import BaseModel, field_validator, ConfigDict
from typing import List, Optional
from ..database import session_scope
from ..models.book import Section, Genre


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
