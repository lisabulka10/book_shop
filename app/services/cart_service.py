import uuid

from flask import session, jsonify
from flask_login import current_user
from sqlalchemy.orm import selectinload

from ..database import session_scope
from ..models.order import CartItem, Cart

from ..schemas.order import CartItemPydantic, CartPydantic


def get_or_create_session_id():
    if "session_id" not in session:
        session['session_id'] = str(uuid.uuid4())
    return session['session_id']


def get_cart(create_if_missing=True):
    with session_scope() as db_session:
        if current_user.is_authenticated:
            cart = db_session.query(Cart).filter_by(user_id=current_user.user_id).first()
        else:
            cart = db_session.query(Cart).filter_by(session_id=get_or_create_session_id()).first()

        if not cart and create_if_missing:
            if current_user.is_authenticated:
                cart = Cart(user_id=current_user.user_id)
            else:
                cart = Cart(session_id=get_or_create_session_id())

            db_session.add(cart)

        db_session.flush()
        if cart:
            cart_pydantic = CartPydantic.model_validate(cart)
            return cart_pydantic

    return cart


def set_cart_form(form):
    cart_item = get_cart_items()
    if not form.items:
        for item in cart_item:
            form.items.append_entry({
                'book_id': item.book.id,
                'count': item.count,
                'selected': True
            })


def change_item_count(item_id, count):
    cart = get_cart(False)
    if not cart:
        raise ValueError('При добавлении товара не найдена корзина')
    with session_scope() as db_session:
        item = db_session.query(CartItem).filter_by(cart_id=cart.id, id=item_id).first()
        item.count = count


def get_total_count_cart_items(selected=False):
    cart = get_cart(False)
    if not cart:
        return 0
    with session_scope() as db_session:
        total_items = db_session.query(CartItem).filter_by(cart_id=cart.id).count()
    return total_items


def get_cart_total_amount(selected=False):
    cart_items = get_cart_items(selected)
    return sum(item.count * item.book.price for item in cart_items)


def add_cart_item_db(book_id):
    cart = get_cart()
    with session_scope() as db_session:
        db_session.add(CartItem(cart_id=cart.id, book_id=book_id, count=1))



def get_cart_items(selected=False):
    cart = get_cart(False)
    if not cart:
        return
    with session_scope() as db_session:
        if selected:
            items = (
                db_session.query(CartItem)
                .filter_by(cart_id=cart.id, selected=True)
                .options(selectinload(CartItem.cart)
                         .options(selectinload(Cart.user)))
                .options(selectinload(CartItem.book))
                .all()
            )
        else:
            items = (
                db_session.query(CartItem)
                .filter_by(cart_id=cart.id)
                .options(selectinload(CartItem.cart)
                         .options(selectinload(Cart.user)))
                .options(selectinload(CartItem.book))
                .all()
            )

        cart_items = [CartItemPydantic.model_validate(item) for item in items]

    return cart_items


def delete_cart_items_all():
    cart = get_cart()
    if not cart:
        return
    with session_scope() as db_session:
        cart_items = db_session.query(CartItem).filter_by(cart_id=cart.id).all()
        for item in cart_items:
            db_session.delete(item)


def delete_cart_item(item_id):
    cart = get_cart()
    with session_scope() as db_session:
        cart_item = db_session.query(CartItem).filter_by(cart_id=cart.id, id=item_id).first()
        db_session.delete(cart_item)


def merge_carts():
    session_id = session.get('session_id')
    if not session_id:
        return

    with session_scope() as db_session:
        user_cart = db_session.query(Cart).filter_by(user_id=current_user.user_id).first()
        guest_cart = db_session.query(Cart).filter_by(session_id=session_id).first()

        if not guest_cart:
            return user_cart

        if not user_cart:
            guest_cart.user_id = current_user.user_id
            guest_cart.session_id = None
            return guest_cart

        for guest_item in guest_cart.cart_items:
            existing_item = (
                db_session.query(CartItem)
                .filter_by(cart_id=user_cart.id, book_id=guest_item.book_id)
                .first()
            )
            if existing_item:
                existing_item.count += guest_item.count
                db_session.delete(guest_item)
            else:
                guest_item.card_id = user_cart.id

        db_session.delete(guest_cart)

        return user_cart


def select_items(items):
    with session_scope() as session_db:
        for item in items:
            try:
                item_id = int(item)
                item = session_db.query(CartItem).filter_by(id=item_id).first()
                item.selected = True
            except Exception as e:
                return False

        return True


def add_count_result(item_id, count):
    if not item_id or not count:
        return jsonify({
            "message": "Произошла ошибка при изменении количества",
        }), 400
    try:
        change_item_count(item_id, count)
        return jsonify({
            "message": "Количество успешно изменено",
            "cart_count": count
        }), 200
    except Exception as e:
        return jsonify({
            "message": "Произошла ошибка при изменении количества",
            "error": e
        }), 400


def update_selected(item_id):
    if not item_id:
        return jsonify({
            "message": "Произошла ошибка при изменении статуса",
        }), 400
    with session_scope() as session_db:
        item = session_db.query(CartItem).filter_by(id=item_id).first()
        if not item:
            return jsonify({
                "message": "Произошла ошибка при изменении статуса. Книга не найдена в бд",
            }), 400
        item.selected = False
        return jsonify({
            "message": "статус успешно изменен",
            "cart_item_id": item_id
        }), 200
