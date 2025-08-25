from flask import Blueprint, render_template

from ..services.main_service import prepare_data_template, get_catalog, get_books_with_sections, \
    get_top_books, get_genre_books, get_genre, get_book

main = Blueprint('main', __name__)


@main.route('/')
def index():
    data_template = prepare_data_template(
        top_book=get_top_books(),
        catalog=get_catalog(),
        sections_with_books=get_books_with_sections()
    )

    return render_template('main/index.html', **data_template)


@main.route('/genre/<int:genre_id>')
def genre_books(genre_id):
    data_template = prepare_data_template(
        catalog=get_catalog(),
        books=get_genre_books(genre_id),
        genre=get_genre(genre_id)
    )

    return render_template('main/genre_catalog.html', **data_template)


@main.route('/book/<int:book_id>')
def book(book_id):
    data_template = prepare_data_template(book=get_book(book_id), catalog=get_catalog())
    return render_template('main/book.html', **data_template)
