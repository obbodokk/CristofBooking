from flask import Flask
from .extensions import db
from .config import Config
from .routes.auth import auth
from .routes.hotels import hotels_bp
from flask_cors import CORS
from .routes.api import api_bp
from .routes.dashboard import dashboard_bp

def create_app(config_class=Config):
    app = Flask(__name__, template_folder='templates')
    app.config.from_object(config_class)

    db.init_app(app)
    CORS(app, resources={r"/*": {"origins": "*"}})
    app.register_blueprint(auth, url_prefix='/api/auth')
    app.register_blueprint(hotels_bp)
    app.register_blueprint(api_bp)
    app.register_blueprint(dashboard_bp)

    with app.app_context():
        db.create_all()  

    return app
