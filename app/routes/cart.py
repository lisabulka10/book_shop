from flask import Blueprint, render_template, redirect, url_for, request, jsonify, flash

from ..services.cart_service import delete_cart_item, get_cart_items, add_cart_item_db, \
    delete_cart_items_all, select_items, add_count_result, get_total_count_cart_items, update_selected

cart_bp = Blueprint('cart', __name__)


@cart_bp.route('/cart/add', methods=['POST'])
def add_to_cart():
    data = request.json
    book_id = data.get('book_id')

    add_cart_item_db(book_id)
    total_items = get_total_count_cart_items()

    return jsonify({
        "message": "Книга успешно добавлена",
        "cart_count": total_items
    })


@cart_bp.route('/cart', methods=['POST', 'GET'])
def cart():
    return render_template('order/cart.html', cart_items=get_cart_items())


@cart_bp.route('/cart/selected', methods=['POST'])
def select():
    selected_books = request.form.getlist("selected-items")

    if not selected_books or not select_items(selected_books):
        flash("Вы не выбрали ни одной книги", "danger")
        return redirect(url_for("cart.cart"))

    return redirect(url_for('order.create_order'))


@cart_bp.route('/cart/update-count', methods=['POST'])
def add_count():
    data = request.json
    item_id = data.get('id')
    count = data.get('count')

    return add_count_result(item_id, count)


@cart_bp.route('/delete')
def delete():
    delete_cart_items_all()
    return redirect(url_for('cart.cart'))


@cart_bp.route('/delete/<int:item_id>')
def delete_item(item_id):
    delete_cart_item(item_id)
    return redirect(url_for('cart.cart'))


@cart_bp.route('/cart/update-selected', methods=['POST'])
def update_select_item():
    data = request.json
    item_id = data.get('id')
    return update_selected(item_id)
