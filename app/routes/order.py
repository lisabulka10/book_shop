import requests

from flask import Blueprint, render_template, redirect, url_for, request, jsonify
from flask_login import login_required

from ..models.order import DeliveryType, PayMethod
from ..forms import AddressFrom, OrderInfoForm

from ..services.main_service import get_catalog, prepare_data_template
from ..services.order_service import load_form_choices, get_user_address, load_form_address_choices, set_addition_form,\
    get_orders_all, get_order, delete_address_db, add_address, create_order_db, get_shop_list, \
    address_details_post_result
from ..services.user_service import set_user_info_form
from ..services.cart_service import get_total_count_cart_items, get_cart_total_amount

order_bp = Blueprint('order', __name__)


@order_bp.route('/map', methods=['POST', 'GET'])
@login_required
def get_address():
    form = AddressFrom()
    load_form_choices(form)

    if form.validate_on_submit():
        if add_address(form):
            return redirect(url_for('order.create_order'))
        else:
            return redirect(url_for('order.get_address'))
    else:
        print(form.errors)
    return render_template('order/map.html', form=form)


@order_bp.route('/order', methods=['POST', 'GET'])
@login_required
def create_order():
    form = OrderInfoForm()

    load_form_address_choices(form)
    set_addition_form(form)
    set_user_info_form(form)

    template_data = prepare_data_template(
        user_addresses=get_user_address(),
        count_items=get_total_count_cart_items(selected=True),
        amount=get_cart_total_amount(selected=True),
        PayMethod=PayMethod,
        DeliveryType=DeliveryType,
        form=form
    )

    if form.validate_on_submit():
        if create_order_db(form):
            return redirect(url_for('order.get_order_list'))

    return render_template('order/order.html', **template_data)


@order_bp.route('/shops/<city_name>', methods=['GET'])
@login_required
def get_shops(city_name):
    return jsonify(get_shop_list(city_name))


@order_bp.route('/make_order', methods=['GET', 'POST'])
@login_required
def make_order():
    return redirect(url_for('order.get_orders_list'))


@order_bp.route('/delete/address/<int:address_id>')
@login_required
def delete_address(address_id):
    delete_address_db(address_id)
    return redirect(url_for('order.create_order'))


@order_bp.route('/order_list', methods=['GET'])
@login_required
def get_order_list():
    template_data = prepare_data_template(catalog=get_catalog(), orders=get_orders_all())
    return render_template('order/order_list.html', **template_data)


@order_bp.route('/order/<int:order_id>')
@login_required
def order(order_id):
    template_data = prepare_data_template(order=get_order(order_id), catalog=get_catalog())
    return render_template('order/order_info.html', **template_data)


@order_bp.route('/order/details', methods=['POST'])
def details():
    data = request.json
    delivery_type = data.get('delivery_type')
    address_id = data.get('address_id')

    return address_details_post_result(delivery_type, address_id)


# Нужно, чтоб введенный номер нормально обрабатывался
@order_bp.route('/geoip')
def geoip():
    try:
        r = requests.get("https://ipapi.co/json")
        return jsonify(r.json())
    except:
        return jsonify({"country_code": "RU"})
