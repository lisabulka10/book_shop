from flask import Blueprint, render_template, request, redirect, url_for, jsonify
from flask_login import login_required, current_user

from ..services.main_service import prepare_data_template, get_catalog, get_books_with_sections, \
    get_top_books, get_genre_books, get_genre, get_book, get_section, search_book, avg_rating,\
    delete_review_db, rate_post_result


main = Blueprint('main', __name__)


@main.route('/')
def index():
    data_template = prepare_data_template(
        top_book=get_top_books(),
        catalog=get_catalog(),
        sections_with_books=get_books_with_sections()
    )

    return render_template('main/index.html', **data_template)


@main.route('/search', methods=['GET'])
def search():
    searched = request.args.get('searched', '')
    if searched.strip():
        data_template = prepare_data_template(catalog=get_catalog(), books=search_book(searched))
        return render_template('main/search.html', **data_template)

    return redirect(url_for('main.index'))


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
    data_template = prepare_data_template(book=get_book(book_id), catalog=get_catalog(), rating=avg_rating(book_id))
    return render_template('main/book.html', **data_template)


@main.route('/book/<int:book_id>/review/<int:review_id>/delete')
@login_required
def delete_review(book_id, review_id):
    delete_review_db(review_id)

    return redirect(url_for('main.book', book_id=book_id))


@main.route('/section/<int:section_id>')
def section_book(section_id):
    data_template = prepare_data_template(section=get_section(section_id), catalog=get_catalog())
    return render_template('main/section_catalog.html', **data_template)


@main.route('/rate', methods=['POST'])
def rate():
    if not current_user.is_authenticated:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return jsonify({'error': 'Unauthorized'}), 401
        return redirect(url_for('user.login', next=request.url))

    data = request.get_json()
    return rate_post_result(data)
