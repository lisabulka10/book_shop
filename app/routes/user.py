import requests

from flask import Blueprint, flash, redirect, url_for, render_template, jsonify, request
from flask_login import login_user, logout_user, login_required

from ..forms import LoginForm, RegistrationForm
from ..services.cart_service import merge_carts
from ..services.user_service import register_ajax_result, verification_code_result, verify_ajax_result, check_login, \
    login_manager

user_bp = Blueprint('user', __name__)


@user_bp.route('/register', methods=['GET', 'POST'])
def register():
    form = RegistrationForm()
    return render_template('user/register.html', form=form)


@user_bp.route('/register_ajax', methods=['POST'])
def register_ajax():
    form = RegistrationForm(data=request.json)
    return register_ajax_result(form)


@user_bp.route('/send_code', methods=['POST'])
@login_required
def verification_code():
    data = request.json
    phone = data.get('phone')
    return verification_code_result(phone)


@user_bp.route('/verify_ajax', methods=['POST'])
def verify_ajax():
    data = request.json
    phone = data.get('phone')
    code = data.get('code')

    return verify_ajax_result(phone, code)


@user_bp.route('/verification')
@login_required
def user_verify():
    return render_template('user/verify.html')


@user_bp.route('/login', methods=['POST', 'GET'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        user = check_login(form)
        if user:
            login_user(user)
            next_page = request.args.get('next')
            merge_carts()
            return redirect(next_page or url_for('main.index'))
        else:
            flash('Неверный email или/и пароль', 'danger')
    return render_template('user/login.html', form=form)


@user_bp.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('main.index'))


# нужно для обработки телефона
@user_bp.route('/geoip')
def geoip():
    try:
        r = requests.get("https://ipapi.co/json")
        return jsonify(r.json())
    except:
        return jsonify({"country_code": "RU"})
