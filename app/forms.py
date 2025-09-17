from flask import request

from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, IntegerField, ValidationError, HiddenField, BooleanField, Form
from wtforms import FieldList, FormField, SelectField, SubmitField, RadioField
from wtforms.validators import InputRequired, Length, Email, EqualTo, DataRequired, NumberRange

from enum import Enum

import phonenumbers
import re

from .models.order import DeliveryType, PayMethod


class PhoneForm(Form):
    country_code = IntegerField('Country Code', validators=[InputRequired()])
    area_code = IntegerField('Area Code/Exchange', validators=[InputRequired()])
    number = StringField('Number')


class LoginForm(FlaskForm):
    email = StringField('Email', validators=[InputRequired(), Email()])
    password = PasswordField('Password', validators=[InputRequired(), Length(min=8, max=36)])
    remember = BooleanField('Remember')


class RegistrationForm(FlaskForm):
    first_name = StringField('Имя', validators=[InputRequired(), Length(max=80)])
    last_name = StringField('Фамилия', validators=[InputRequired(), Length(max=80)])
    email = StringField('Email', validators=[InputRequired(), Email()])
    phone = StringField('Телефон', validators=[DataRequired()])
    password = PasswordField('Пароль', validators=[InputRequired(), Length(min=8, max=36)])
    confirm_password = PasswordField('Повторите пароль', validators=[InputRequired(), EqualTo("password")])
    def validate_phone(form, field):
        try:
            # Пытаемся распарсить с указанием региона "RU"
            parsed = phonenumbers.parse(field.data, "RU")
            print(f'form validate parse = {parsed}')
            if not phonenumbers.is_valid_number(parsed):
                raise ValidationError("Некорректный номер телефона")
            # Можно вернуть в формате E164 для хранения
            field.data = phonenumbers.format_number(parsed, phonenumbers.PhoneNumberFormat.E164)
        except phonenumbers.NumberParseException:
            raise ValidationError("Некорректный номер телефона")


class VerifyForm(FlaskForm):
    code = IntegerField('Код', validators=[InputRequired(), NumberRange(min=1000, max=9999)])
    submit = SubmitField('Зарегистрироваться')


class Country(Enum):
    RU = "Россия"
    KZ = 'Казахстан'
    BY = 'Беларусь'


class AddressFrom(FlaskForm):
    delivery_type = SelectField('Доставка',
                                choices=[
                                    (DeliveryType.COURIER.name, DeliveryType.COURIER.value),
                                    (DeliveryType.PICKUP.name, DeliveryType.PICKUP.value)
                                ])
    country = SelectField('Страна', choices=[item.value for item in Country])
    city = StringField('Населенный пункт', validators=[Length(max=200)])
    address = StringField('Адрес')
    city_shop = SelectField('Город', choices=[])
    shops = SelectField('Пункт самовывоза', choices=[(0, '- Выберите магазин - ')], coerce=int, validate_choice=False,
                        default=0)
    accept = SubmitField('Далее')

    def validate_form(self):
        if not FlaskForm.validate(self):
            return False
        if self.delivery_type.data.lower() == 'courier':
            if not self.city.data:
                self.city.errors.append('Выберите город')
                return False
            if not self.address.data:
                self.address.errors.append('Выберите адрес')
                return False
        elif self.delivery_type.data.lower() == 'pickup':
            if not self.shops.data or int(self.shops.data) == 0:
                self.shops.errors.append('Выберите магазин из списка')
                return False
        return True


class OrderInfoForm(FlaskForm):
    office = StringField('№кв./оф.', validators=[Length(max=10)])
    entrance = StringField('Подъезд', validators=[Length(max=10)])
    intercom = StringField('Домофон', validators=[Length(max=10)])
    floor = StringField('Этаж', validators=[Length(max=10)])
    phone = StringField('Телефон', validators=[DataRequired()])
    first_name = StringField('Имя', validators=[InputRequired(), Length(max=80)])
    last_name = StringField('Фамилия', validators=[InputRequired(), Length(max=80)])
    pay_method = RadioField('Способ оплаты',
                            choices=[
                                (PayMethod.SBP.name, PayMethod.SBP.value),
                                (PayMethod.CARD.name, PayMethod.CARD.value),
                                (PayMethod.RECEIPT.name, PayMethod.RECEIPT.value)
                            ],
                            validators=[DataRequired()])
    address = RadioField('Адрес', choices=[], validators=[DataRequired()], coerce=int)
    accept = SubmitField('Оформить заказ')

    def validate_phone(form, field):
        try:
            # Пытаемся распарсить с указанием региона "RU"
            parsed = phonenumbers.parse(field.data, "RU")
            print(f'form validate parse = {parsed}')
            if not phonenumbers.is_valid_number(parsed):
                raise ValidationError("Некорректный номер телефона")
            # Можно вернуть в формате E164 для хранения
            field.data = phonenumbers.format_number(parsed, phonenumbers.PhoneNumberFormat.E164)
        except phonenumbers.NumberParseException:
            raise ValidationError("Некорректный номер телефона")


class CartItemForm(FlaskForm):
    book_id = HiddenField()
    selected = BooleanField()
    count = HiddenField()

    class Meta:
        csrf = False  # y

class CartForm(FlaskForm):
    items = FieldList(FormField(CartItemForm))
    submit = SubmitField('Оформить заказ')


class SearchForm(FlaskForm):
    searched = StringField('Поиск', validators=[DataRequired()])
    submit = SubmitField('Искать')
