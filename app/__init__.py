from flask import Flask
from .config import settings

from .database import init_db

from .routes.main import main
from .routes.user import user_bp, login_manager
from .routes.order import order_bp
from .routes.cart import cart_bp



def create_app():
    app = Flask(__name__, static_folder='static', template_folder='templates')
    app.config['SECRET_KEY'] = settings.SECRET_KEY

    login_manager.init_app(app)

    app.register_blueprint(main)
    app.register_blueprint(user_bp)
    app.register_blueprint(order_bp)
    app.register_blueprint(cart_bp)


    init_db()
    return app
