from flask import Flask
from flask_cors import CORS
from .extensions import db
from .config import Config
from .routes.auth import auth
from .routes.hotels import hotels_bp
from .routes.api import api_bp
from .routes.dashboard import dashboard_bp
from .routes.main import main_bp
from .models import User, Hotel

def create_app(config_class=Config):
    app = Flask(__name__, template_folder='templates')
    app.config.from_object(config_class)

    CORS(app)
    db.init_app(app)

    app.register_blueprint(auth, url_prefix='/api/auth')
    app.register_blueprint(hotels_bp)
    app.register_blueprint(api_bp)
    app.register_blueprint(dashboard_bp)
    app.register_blueprint(main_bp)

    with app.app_context():
        db.create_all()

    return app
