import random
import redis

from flask import flash, redirect, url_for, request, jsonify
from flask_login import current_user, LoginManager

from app.config import settings

from werkzeug.security import generate_password_hash, check_password_hash

from ..database import session_scope
from ..models.user import User
from ..schemas.user import UserPydantic

redis_client = redis.Redis(
    host=settings.REDIS_HOST,
    port=settings.REDIS_PORT,
    db=0,
    decode_responses=True
)

login_manager = LoginManager()
login_manager.login_view = 'user.login'
login_manager.login_message = 'Вам необходимо зарегистрироваться и/или зайти в аккаунт'
login_manager.login_message_category = 'info'


@login_manager.unauthorized_handler
def unauthorized_callback():
    if request.is_json or request.headers.get("X-Requested-With") == "XMLHttpRequest":
        return jsonify({"error": "unauthorized"}), 401
    return redirect(url_for('user.login', next=request.url))


@login_manager.user_loader
def load_user(user_id):
    with session_scope() as session:
        user = session.query(User).get(user_id)
        if user:
            session.expunge(user)

        return user


def send_verification_code(phone):
    code = random.randint(1000, 9999)
    ttl = 300
    redis_client.setex(f"verify:{phone}", ttl, code)

    print(f'Код для {phone}: {code}')
    return code


def check_register_data(form):
    with session_scope() as session:
        user = session.query(User).filter_by(email=form.email.data).first()

        if user:
            flash('Пользователь с таким email уже зарегистрирован.', 'danger')
            return False

        user = session.query(User).filter_by(phone=form.phone.data).first()
        if user:
            flash('Пользователь с таким номером телефона уже зарегистрирован.', 'danger')
            return False

        user = User(
            first_name=form.first_name.data,
            last_name=form.last_name.data,
            email=form.email.data,
            phone=form.phone.data,
            password_hash=generate_password_hash(form.password.data)
        )
        session.add(user)
        return True


def register_ajax_result(form):
    try:
        if not form.validate():
            return jsonify({
                'success': False,
                'errors': form.errors,
            }), 400

        if not check_register_data(form):
            return jsonify({
                'success': False,
                'errors': ['Аккаунт с таким телефоном или email уже существует']
            }), 400
        else:
            code = send_verification_code(form.phone.data)
            return jsonify({
                'success': True,
                'message': f'Код отправлен на телефон: {code}'
            }), 200
    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'errors': str(e)}), 500


def verification_code_result(phone):
    if not phone:
        return jsonify({'success': False, 'message': 'Номер не найден'}), 400
    send_verification_code(phone)
    return jsonify({
        'success': True,
        'message': 'Код отправлен на телефон'
    }), 200


def get_code_radis(phone):
    return redis_client.get(f"verify:{phone}")


def user_verified(phone):
    with session_scope() as session:
        user = session.query(User).filter_by(phone=phone).first()
        if not user:
            print(f'user is not found')
            return False
        user.is_verified = True
        redis_client.delete(f"verify:{phone}")
        return True


def verify_ajax_result(phone, code):
    stored_code = get_code_radis(phone)
    if not stored_code:
        return jsonify({'success': False, 'message': 'Код не найден или просрочен'}), 400

    if code != stored_code:
        return jsonify({'success': False, 'message': 'Неверный код'}), 400

    if not user_verified(phone):
        return jsonify({'success': False, 'message': 'Пользователь не найден'}), 404

    return jsonify({'success': True, 'message': 'Верификация прошла успешно'}), 200


def check_login(form):
    with session_scope() as session:
        user = session.query(User).filter_by(email=form.email.data).first()
        if user and check_password_hash(user.password_hash, form.password.data):
            return user
        else:
            return False


def get_user_info():
    with session_scope() as session:
        user_db = session.query(User).filter_by(user_id=current_user.user_id).first()
        user = UserPydantic.model_validate(user_db)
    return user


def set_user_info_form(form):
    user = get_user_info()

    form.first_name.data = user.first_name
    form.last_name.data = user.last_name

    return user
