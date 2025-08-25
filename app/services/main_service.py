from flask import Blueprint, render_template, flash, redirect, url_for
from sqlalchemy.orm import selectinload
from pydantic import TypeAdapter
import random

from ..database import session_scope
from ..models.book import Section, Genre, Book
from ..schemas.book import SectionPydantic, GenrePydantic, BookPydantic


def prepare_data_template(**kwargs):
    template_data = {}
    for key, value in kwargs.items():
        template_data[key] = value

    return template_data


def get_catalog():
    with session_scope() as session:
        sections = (
            session.query(Section)
            .options(selectinload(Section.genres).selectinload(Genre.books))
            .all()
        )
        catalog = [SectionPydantic.model_validate(section) for section in sections]

        return catalog


def get_book(book_id):
    with session_scope() as session:
        book_db = (
            session.query(Book)
            .filter_by(id=book_id)
            .options(selectinload(Book.author))
        )
        book = BookPydantic.model_validate(book_db)
    return book


def get_books_with_sections():
    with session_scope() as session:
        sections = (
            session.query(Section)
            .options(selectinload(Section.genres).selectinload(Genre.books))
            .all()
        )
        sections_with_books = []
        for section in sections:
            books = []
            for genre in section.genres:
                books.extend(genre.books)

            random.shuffle(books)
            sections_with_books.append(
                {
                    "section": section,
                    "books": books
                }
            )

    return sections_with_books


def get_top_books():
    with session_scope() as session:
        books_db = session.query(Book).all()
        books = [BookPydantic.model_validate(book) for book in books_db]

    random.shuffle(books)
    return books[::5]


def get_book(book_id):
    with session_scope() as session:
        book_db = session.query(Book).get(book_id)
        book = BookPydantic.model_validate(book_db)

    return book


def get_genre_books(genre_id):
    with session_scope() as session:
        books = (
            session.query(Book)
            .filter_by(genre_id=genre_id)
            .all()
        )
        all_books = [BookPydantic.model_validate(book) for book in books]
    return all_books


def get_genre(genre_id):
    with session_scope() as session:
        genre_db = session.query(Genre).filter_by(id=genre_id).first()
        genre = GenrePydantic.model_validate(genre_db)
    return genre
