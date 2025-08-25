from . import Base
from sqlalchemy import Integer, String, Column, Float, ForeignKey, Enum
from sqlalchemy.orm import relationship
from datetime import datetime

from enum import Enum as EnumClass


class Binding(EnumClass):
    HARD = 'Твердый'
    SOFT = 'Мягкий'


class Book(Base):
    __tablename__ = 'books'

    id = Column(Integer, primary_key=True)
    author_id = Column(Integer, ForeignKey("authors.id"))
    genre_id = Column(Integer, ForeignKey("genres.id"))
    title = Column(String(300))
    price = Column(Float)
    book_cover = Column(String(200))
    description = Column(String)
    publishing = Column(String)
    year = Column(Integer)
    binding = Column(String(50))  # Column(Enum(Binding))

    author = relationship("Author", back_populates="books", uselist=False)
    genres = relationship("Genre", back_populates="books")
    order_items = relationship('OrderItem', back_populates='book', cascade="all, delete")
    cart_items = relationship('CartItem', back_populates='book', cascade="all, delete")


class Author(Base):
    __tablename__ = 'authors'

    id = Column(Integer, primary_key=True)
    name = Column(String(150))

    books = relationship("Book", back_populates="author", cascade="all, delete")


class Genre(Base):
    __tablename__ = 'genres'

    id = Column(Integer, primary_key=True)
    name = Column(String(250))
    section_id = Column(Integer, ForeignKey('sections.id'))

    books = relationship("Book", back_populates="genres")
    section = relationship('Section', back_populates='genres', uselist=False)


class Section(Base):
    __tablename__ = 'sections'

    id = Column(Integer, primary_key=True)
    name = Column(String(250))

    genres = relationship('Genre', back_populates='section', cascade="all, delete")


class Review(Base):
    __tablename__ = 'reviews'

    id = Column(Integer, primary_key=True)
    rating = Column(Integer)
    text = Column(String)

    user_review = relationship('UserReview', back_populates='review', uselist=False)


class UserReview(Base):
    __tablename__ = 'user_review'

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.user_id'))
    review_id = Column(Integer, ForeignKey('reviews.id'))

    user = relationship('User', back_populates='user_review', uselist=False)
    review = relationship('Review', back_populates='user_review')
