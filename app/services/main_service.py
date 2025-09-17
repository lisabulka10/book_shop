from flask import jsonify
from sqlalchemy.orm import selectinload
from sqlalchemy import or_, func

import random
from flask_login import current_user

from ..database import session_scope
from ..models.book import Section, Genre, Book, Review, UserReview, Author
from ..models.order import OrderItem
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
            .options(selectinload(Book.reviews)
                     .options(selectinload(Review.user_review)
                              .options(selectinload(UserReview.user))))
            .first()
        )
        if book_db:
            book = BookPydantic.model_validate(book_db)
            return book
        else:
            return None


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
        books_db = (
            session.query(Book, func.avg(Review.rate).label('average'))
            .outerjoin(Review, Review.book_id == Book.id)
            .group_by(Book.id)
            .order_by(func.avg(Review.rate).desc())
            .all()
        )
        book_db2 = (
            session.query(Book)
            .join(OrderItem, OrderItem.book_id == Book.id)
            .all()
        )

        books = []

        for book in book_db2[:3]:
            books.append(book)

        if not book_db2:
            books = session.query(Book).all()
            books = books[:3]

        #books = [BookPydantic.model_validate(book) for book in books_arr]
    #random.shuffle(books)
        return books


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


def get_section(section_id):
    with session_scope() as session:
        section_db = (
            session.query(Section).filter_by(id=section_id)
            .options(selectinload(Section.genres)
                     .options(selectinload(Genre.books)))
            .first()
        )
        section = SectionPydantic.model_validate(section_db)

    return section


def add_review(book_id, value, text=None):
    with session_scope() as session:
        review = (
            session.query(Review)
            .join(UserReview, Review.id == UserReview.review_id)
            .filter(UserReview.user_id == current_user.user_id, Review.book_id == book_id)
            .first()
        )

        if review:
            review.rate = value
            if text:
                review.text = text
        else:
            new_review = Review(book_id=book_id, text=text, rate=value)
            session.add(new_review)
            session.flush()
            user_review = UserReview(user_id=current_user.user_id, review_id=new_review.id)
            session.add(user_review)

        return True


def search_book(search_string):
    with session_scope() as session:
        books_db = (session.query(Book)
                    .join(Book.author)
                    .options(selectinload(Book.author))
                    .filter(
                        or_(
                            Book.title.ilike(f'%{search_string}%'),
                            Author.name.ilike(f'%{search_string}%')
                        )
                    )
                    .all()
                    )
        books = [BookPydantic.model_validate(book) for book in books_db]

    return books


def delete_review_db(review_id):
    with session_scope() as session:
        review = session.query(Review).get(review_id)
        user_review = session.query(UserReview).filter_by(review_id=review_id).first()
        session.delete(review)
        session.delete(user_review)

        return


def avg_rating(book_id):
    with session_scope() as session:
        rating_count = (
            session.query(Review).filter_by(book_id=book_id).count()
        )
        rating_sum = session.query(func.sum(Review.rate)).filter_by(book_id=book_id).scalar()

        if not rating_sum:
            return None

        return round(rating_sum/rating_count, 1)


def rate_post_result(data):
    if not data:
        return jsonify({'error': 'Нет данных'}), 400

    book_id = data.get('book_id')
    value = data.get('value')
    text = data.get('text', '')

    if not book_id or not value:
        return jsonify({'error': 'Не переданы обязательные поля'}), 400

    try:
        add_review(book_id=book_id, value=value, text=text)
    except Exception as e:
        return jsonify({'error': f'Ошибка при добавлении рецензии: {str(e)}'}), 500

    return jsonify({'success': True})
