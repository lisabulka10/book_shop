import requests

from flask import Blueprint, flash, redirect, url_for, render_template, jsonify,\
    request, make_response
from flask_login import login_user, logout_user, LoginManager

from ..database import session_scope
from ..models.user import User
from ..forms import PhoneForm, LoginForm, RegistrationForm
from ..services.cart_service import merge_carts
from werkzeug.security import generate_password_hash, check_password_hash


user_bp = Blueprint('user', __name__)

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


@user_bp.route('/register', methods=['GET', 'POST'])
def register():
    form = RegistrationForm()
    if form.validate_on_submit():
        with session_scope() as session:
            user = session.query(User).filter_by(email=form.email.data).first()

            if user:
                flash('User with this email is already exists.', 'danger')
                return redirect(url_for('user.register', form=form))

            user = User(
                first_name=form.first_name.data,
                last_name=form.last_name.data,
                email=form.email.data,
                phone=form.phone.data,
                password_hash=generate_password_hash(form.password.data)
            )
            session.add(user)

        return redirect(url_for('user.login'))
    elif form.errors:
        flash(form.errors, 'danger')

    return render_template('user/register.html', form=form)


@user_bp.route('/login', methods=['POST', 'GET'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        with session_scope() as session:
            user = session.query(User).filter_by(email=form.email.data).first()
            if user and check_password_hash(user.password_hash, form.password.data):
                login_user(user)
                next_page = request.args.get('next')
                session_id = request.cookies.get('cart_id')
                if session_id:
                    merge_carts(session_id)
                resp = make_response(redirect(next_page or url_for('main.index')))
                resp.delete_cookie("cart_id")
                return resp

        flash('Неверный email или/и пароль', 'danger')
    return render_template('user/login.html', form=form)


@user_bp.route('/logout')
def logout():
    logout_user()
    resp = make_response(redirect(url_for('main.index')))
    resp.delete_cookie("cart_id")
    return resp


@user_bp.route('/geoip')
def geoip():
    try:
        r = requests.get("https://ipapi.co/json")
        return jsonify(r.json())
    except:
        return jsonify({"country_code": "RU"})
