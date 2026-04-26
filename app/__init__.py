from flask import Flask
from .extensions import db
from .config import Config
from .routes.auth import auth
from .routes.routes import routes
from .models import User  

def create_app(config_class=Config):
    app = Flask(__name__, template_folder='templates')
    app.config.from_object(config_class)

    db.init_app(app)

    app.register_blueprint(auth, url_prefix='/api/auth')
    app.register_blueprint(routes)

    with app.app_context():
        db.create_all()  

    return app
