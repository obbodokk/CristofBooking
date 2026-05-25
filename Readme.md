CristofBooking backend test using PyTest🧪

📐Models test📐

№1 test_models_init_exports.py

from flask import Flask
from app import create_app
import app.extensions as extensions
from app.routes.auth import auth
from app.routes.hotels import hotels_bp
from app.routes.api import api_bp
from app.routes.dashboard import dashboard_bp
from app.routes.main import main_bp


def test_create_app(monkeypatch):
    

    init_called = {"value": False}
    create_all_called = {"value": False}

    def fake_init_app(app):
        init_called["value"] = True

    monkeypatch.setattr(extensions.db, "init_app", fake_init_app)

    def fake_create_all():
        create_all_called["value"] = True

    monkeypatch.setattr(extensions.db, "create_all", fake_create_all)

    app = create_app()

    assert isinstance(app, Flask)

    assert "auth" in app.blueprints
    assert "hotels" in app.blueprints
    assert "api" in app.blueprints
    assert "dashboard" in app.blueprints
    assert "main" in app.blueprints

    assert init_called["value"] is True
    assert create_all_called["value"] is True

№2 test_amenity_model.py

from app.models.amenity import Amenity

def test_amenity_to_dict():
    amenity = Amenity(
        amenitie_id=1,
        name="Wi-Fi",
        icon_url="https://example.com/wifi.png"
    )

    result = amenity.to_dict()

    assert result["id"] == 1
    assert result["name"] == "Wi-Fi"
    assert result["icon_url"] == "https://example.com/wifi.png"
№3 test_booking_models.py

from datetime import date, datetime
from app.models.booking import Booking

def test_booking_to_dict():
    check_in = date(2024, 5, 10)
    check_out = date(2024, 5, 15)
    booked_at = datetime(2024, 5, 1, 12, 30)

    booking = Booking(
        booking_id=1,
        user_id=10,
        hotel_id=20,
        room_id=30,
        check_in_date=check_in,
        check_out_date=check_out,
        total_price=1500.50,
        status="confirmed",
        booked_at=booked_at,
        number_of_guests=2
    )

    result = booking.to_dict()

    assert result["id"] == 1
    assert result["user_id"] == 10
    assert result["hotel_id"] == 20
    assert result["room_id"] == 30
    assert result["check_in"] == "2024-05-10"
    assert result["check_out"] == "2024-05-15"
    assert result["total_price"] == 1500.50
    assert result["status"] == "confirmed"
    assert result["booked_at"] == booked_at.isoformat()

№4 test_guest_model.py

from datetime import datetime
from app.models.guest import Guest

def test_guest_to_dict():
    registered_at = datetime(2024, 5, 10, 14, 30)

    guest = Guest(
        guest_id=1,
        first_name="John",
        last_name="Doe",
        email="john@example.com",
        phone="+123456789",
        country="USA",
        registered_at=registered_at
    )

    result = guest.to_dict()

    assert result["id"] == 1
    assert result["first_name"] == "John"
    assert result["last_name"] == "Doe"
    assert result["email"] == "john@example.com"
    assert result["phone"] == "+123456789"
    assert result["country"] == "USA"
    assert result["registered_at"] == registered_at

№5 test_hotel_model.py

from datetime import datetime
from app.models.hotel import Hotel

def test_hotel_to_dict():
    hotel = Hotel(
        hotel_id=1,
        hotel_name="Grand Hotel",
        description="Luxury hotel in the city center",
        country="USA",
        city="New York",
        address="5th Avenue 123",
        star_rating=5,
        phone="+123456789",
        email="info@grandhotel.com",
        website="https://grandhotel.com",
        amenities=["wifi", "pool", "spa"],
        image_main_url="https://example.com/main.jpg",
        image_gallery_urls=["https://example.com/1.jpg", "https://example.com/2.jpg"],
        created_at=datetime(2024, 5, 10)
    )

    result = hotel.to_dict()

    assert result["id"] == 1
    assert result["name"] == "Grand Hotel"
    assert result["description"] == "Luxury hotel in the city center"
    assert result["location"] == "New York, USA"
    assert result["address"] == "5th Avenue 123"
    assert result["rating"] == 5
    assert result["image_url"] == "https://example.com/main.jpg"
    assert result["amenities"] == ["wifi", "pool", "spa"]
    assert result["phone"] == "+123456789"
    assert result["email"] == "info@grandhotel.com"

№6 test_room_model.py

from decimal import Decimal
from app.models.room import Room


def test_room_to_dict_full():
    room = Room(
        room_id=1,
        hotel_id=10,
        room_type="Deluxe",
        description="Large room with sea view",
        max_guests=3,
        price_per_night=Decimal("199.99"),
        amenities=["WiFi", "TV"],
        is_available=True,
        image_url="https://example.com/room.jpg"
    )

    result = room.to_dict()

    assert result == {
        "id": 1,
        "hotel_id": 10,
        "type": "Deluxe",
        "price": 199.99,
        "available": True,
        "image": "https://example.com/room.jpg",
        "description": "Large room with sea view",
        "max_guests": 3
    }


def test_room_to_dict_price_none():
    room = Room(
        room_id=2,
        hotel_id=20,
        room_type="Standard",
        description="Simple room",
        max_guests=2,
        price_per_night=None,
        amenities=[],
        is_available=False,
        image_url=None
    )

    result = room.to_dict()

    assert result["price"] == 0
    assert result["available"] is False
    assert result["type"] == "Standard"
    assert result["id"] == 2
    assert result["hotel_id"] == 20
    assert result["description"] == "Simple room"
    assert result["max_guests"] == 2

№7 test_user_model.py

from datetime import datetime
from app.models.user import User


def test_user_set_password_and_check():

    user = User(
        id=1,
        email="test@example.com",
        username="tester",
        password_hash="",
        role="user",
        created_at=datetime.utcnow()
    )

    user.set_password("secret123")

    assert user.password_hash != ""
    assert "secret123" not in user.password_hash

    assert user.check_password("secret123") is True

    assert user.check_password("wrongpass") is False


def test_user_to_dict():
    
    created = datetime(2024, 1, 1, 12, 0, 0)

    user = User(
        id=5,
        email="john@example.com",
        username="johnny",
        password_hash="hashed",
        role="admin",
        created_at=created
    )

    result = user.to_dict()

    assert result == {
        "id": 5,
        "email": "john@example.com",
        "username": "johnny",
        "role": "admin",
        "created_at": created.isoformat()
    }

🧭Routes Test🧭

№1 test_api_routes.py

import json
import jwt
import builtins
from flask import Flask
from app.routes.api import api_bp
import app.routes.api as api_module


def setup_app():
    app = Flask(__name__)
    app.config["STRIPE_SECRET_KEY"] = "TEST_KEY"
    app.register_blueprint(api_bp)
    return app.test_client()


def test_get_rooms(monkeypatch):
    class FakeRoom:
        def to_dict(self):
            return {"id": 1, "name": "Room 101"}

    class FakeQuery:
        def filter_by(self, **kwargs):
            return self
        def all(self):
            return [FakeRoom()]

    class FakeRoomModel:
        query = FakeQuery()

    monkeypatch.setattr(api_module, "Room", FakeRoomModel)

    client = setup_app()
    response = client.get("/api/hotels/1/rooms")

    assert response.status_code == 200
    assert response.json == [{"id": 1, "name": "Room 101"}]



def test_get_amenities(monkeypatch):
    class FakeAmenity:
        def to_dict(self):
            return {"id": 1, "name": "WiFi"}

    class FakeQuery:
        def all(self):
            return [FakeAmenity()]

    class FakeAmenityModel:
        query = FakeQuery()

    monkeypatch.setattr(api_module, "Amenity", FakeAmenityModel)

    client = setup_app()
    response = client.get("/api/amenities")

    assert response.status_code == 200
    assert response.json == [{"id": 1, "name": "WiFi"}]



def test_create_booking_no_token():
    client = setup_app()
    response = client.post("/api/bookings", json={})

    assert response.status_code == 401
    assert response.json == {"error": "No token"}



def test_create_booking_invalid_token(monkeypatch):
    def fake_decode(*a, **k):
        raise Exception("bad token")

    monkeypatch.setattr(jwt, "decode", fake_decode)

    client = setup_app()
    response = client.post(
        "/api/bookings",
        headers={"Authorization": "Bearer BAD"},
        json={}
    )

    assert response.status_code == 401
    assert response.json == {"error": "Invalid token"}



def test_create_booking_success(monkeypatch):
    monkeypatch.setattr(jwt, "decode", lambda *a, **k: {"user_id": 10})

    class FakeBooking:
        def __init__(self, **kwargs):
            self.data = kwargs

    class FakeSession:
        def add(self, obj): pass
        def commit(self): pass

    monkeypatch.setattr(api_module, "Booking", FakeBooking)
    monkeypatch.setattr(api_module.db, "session", FakeSession())

    client = setup_app()
    response = client.post(
        "/api/bookings",
        headers={"Authorization": "Bearer VALID"},
        json={
            "hotel_id": 1,
            "room_id": 2,
            "check_in": "2024-01-01",
            "check_out": "2024-01-05",
            "total_price": 500,
            "number_of_guests": 2
        }
    )

    assert response.status_code == 201
    assert response.json == {"message": "ok"}



def test_get_user_bookings(monkeypatch):
    class FakeBooking:
        def to_dict(self):
            return {"id": 1, "hotel": "Test Hotel"}

    class FakeQuery:
        def filter_by(self, **kwargs):
            return self
        def all(self):
            return [FakeBooking()]

    class FakeBookingModel:
        query = FakeQuery()

    monkeypatch.setattr(api_module, "Booking", FakeBookingModel)

    client = setup_app()
    response = client.get("/api/users/5/bookings")

    assert response.status_code == 200
    assert response.json == [{"id": 1, "hotel": "Test Hotel"}]



def test_get_guests(monkeypatch):
    class FakeGuest:
        def to_dict(self):
            return {"id": 1, "name": "John"}

    class FakeQuery:
        def all(self):
            return [FakeGuest()]

    class FakeGuestModel:
        query = FakeQuery()

    monkeypatch.setattr(api_module, "Guest", FakeGuestModel)

    client = setup_app()
    response = client.get("/api/guests")

    assert response.status_code == 200
    assert response.json == [{"id": 1, "name": "John"}]


def test_get_about_success(monkeypatch):
    fake_data = {"project": "CristofBooking"}

    def fake_open(*a, **k):
        class FakeFile:
            def __enter__(self): return self
            def __exit__(self, *exc): pass
            def read(self): return json.dumps(fake_data)
        return FakeFile()

    monkeypatch.setattr(builtins, "open", fake_open)

    client = setup_app()
    response = client.get("/api/about")

    assert response.status_code == 200
    assert response.json == fake_data


def test_get_about_not_found(monkeypatch):
    def fake_open(*a, **k):
        raise FileNotFoundError

    monkeypatch.setattr(builtins, "open", fake_open)

    client = setup_app()
    response = client.get("/api/about")

    assert response.status_code == 404
    assert response.json == {"error": "about.json not found"}



def test_get_hash():
    client = setup_app()
    response = client.get("/api/hash/hello")

    assert response.status_code == 200
    assert response.json["input"] == "hello"
    assert len(response.json["hash"]) == 64
    assert response.json["algorithm"] == "sha256"



def test_delete_booking_success(monkeypatch):
    class FakeBooking:
        pass

    class FakeQuery:
        @staticmethod
        def get(id):
            return FakeBooking()

    class FakeSession:
        def delete(self, obj): pass
        def commit(self): pass

    monkeypatch.setattr(api_module, "Booking", type("B", (), {"query": FakeQuery()}))
    monkeypatch.setattr(api_module.db, "session", FakeSession())

    client = setup_app()
    response = client.delete("/api/bookings/1")

    assert response.status_code == 200
    assert response.json == {"message": "deleted"}


def test_delete_booking_not_found(monkeypatch):
    class FakeQuery:
        @staticmethod
        def get(id):
            return None

    monkeypatch.setattr(api_module, "Booking", type("B", (), {"query": FakeQuery()}))

    client = setup_app()
    response = client.delete("/api/bookings/999")

    assert response.status_code == 404
    assert response.json == {"error": "Not found"}


def test_pay_booking_no_key(monkeypatch):
    client = setup_app()
    client.application.config["STRIPE_SECRET_KEY"] = None

    response = client.post("/api/bookings/1/pay")

    assert response.status_code == 500
    assert response.json == {"error": "Stripe key not set"}


def test_pay_booking_not_found(monkeypatch):
    class FakeQuery:
        @staticmethod
        def get(id):
            return None

    monkeypatch.setattr(api_module, "Booking", type("B", (), {"query": FakeQuery()}))

    client = setup_app()
    response = client.post("/api/bookings/999/pay")

    assert response.status_code == 404
    assert response.json == {"error": "Booking not found"}


def test_pay_booking_success(monkeypatch):
    class FakeBooking:
        status = "pending"

    class FakeQuery:
        @staticmethod
        def get(id):
            return FakeBooking()

    class FakeSession:
        def commit(self): pass

    monkeypatch.setattr(api_module, "Booking", type("B", (), {"query": FakeQuery()}))
    monkeypatch.setattr(api_module.db, "session", FakeSession())

    client = setup_app()
    response = client.post("/api/bookings/1/pay")

    assert response.status_code == 200
    assert response.json["success"] is True
    assert response.json["booking_id"] == 1

№2 test_auth_routhes.py

import jwt
from flask import Flask
from app.routes.auth import auth
import app.routes.auth as auth_module


def setup_app():
    app = Flask(__name__)
    app.config["JWT_SECRET_KEY"] = "JWT_SECRET_KEY"
    app.register_blueprint(auth)
    return app.test_client()



def test_register_success(monkeypatch):
    
    class FakeQuery:
        def filter_by(self, **kwargs):
            return self
        def first(self):
            return None  # email свободен

    class FakeUser:
        query = FakeQuery()

        def __init__(self, email, username):
            self.email = email
            self.username = username
            self.password = None

        def set_password(self, pwd):
            self.password = pwd

        def to_dict(self):
            return {"email": self.email, "username": self.username}

    class FakeSession:
        def add(self, obj): pass
        def commit(self): pass

    monkeypatch.setattr(auth_module, "User", FakeUser)
    monkeypatch.setattr(auth_module.db, "session", FakeSession())

    client = setup_app()
    response = client.post("/register", json={
        "email": "test@mail.com",
        "username": "test",
        "password": "1234"
    })

    assert response.status_code == 201
    assert response.json["message"] == "Registered successfully"



def test_register_email_exists(monkeypatch):

    class FakeUser:
        pass

    class FakeQuery:
        def filter_by(self, **kwargs):
            return self
        def first(self):
            return FakeUser()  # email занят

    FakeUser.query = FakeQuery()

    monkeypatch.setattr(auth_module, "User", FakeUser)

    client = setup_app()
    response = client.post("/register", json={
        "email": "exists@mail.com",
        "username": "test",
        "password": "1234"
    })

    assert response.status_code == 409
    assert response.json == {"error": "Email already exists"}



def test_login_invalid_credentials(monkeypatch):

    class FakeQuery:
        def filter_by(self, **kwargs):
            return self
        def first(self):
            return None  # пользователь не найден

    class FakeUser:
        query = FakeQuery()

    monkeypatch.setattr(auth_module, "User", FakeUser)

    client = setup_app()
    response = client.post("/login", json={
        "email": "wrong@mail.com",
        "password": "1234"
    })

    assert response.status_code == 401
    assert response.json == {"error": "Invalid credentials"}


def test_login_success(monkeypatch):

    class FakeUser:
        id = 10

        def check_password(self, pwd):
            return True

        def to_dict(self):
            return {"id": 10, "email": "test@mail.com"}

    class FakeQuery:
        def filter_by(self, **kwargs):
            return self
        def first(self):
            return FakeUser()

    FakeUser.query = FakeQuery()

    monkeypatch.setattr(auth_module, "User", FakeUser)
    monkeypatch.setattr(jwt, "encode", lambda *a, **k: "FAKE_TOKEN")

    client = setup_app()
    response = client.post("/login", json={
        "email": "test@mail.com",
        "password": "1234"
    })

    assert response.status_code == 200
    assert response.json["token"] == "FAKE_TOKEN"
    assert response.json["user"]["id"] == 10

def test_me_success(monkeypatch):

    class FakeUser:
        id = 10
        def to_dict(self):
            return {"id": 10, "email": "test@mail.com"}

    class FakeQuery:
        @staticmethod
        def get(id):
            return FakeUser()

    class FakeUserModel:
        query = FakeQuery()

    monkeypatch.setattr(auth_module, "User", FakeUserModel)
    monkeypatch.setattr(jwt, "decode", lambda *a, **k: {"user_id": 10})

    client = setup_app()
    response = client.get("/me", headers={"Authorization": "Bearer VALID"})

    assert response.status_code == 200
    assert response.json["id"] == 10


def test_me_invalid_token(monkeypatch):

    def fake_decode(*a, **k):
        raise Exception("bad token")

    monkeypatch.setattr(jwt, "decode", fake_decode)

    client = setup_app()
    response = client.get("/me", headers={"Authorization": "Bearer BAD"})

    assert response.status_code == 401
    assert response.json == {"error": "Invalid token"}

№3 test_dashboard_routes.py

from flask import Flask
from app.routes.dashboard import dashboard_bp
import app.routes.dashboard as dashboard_module


def setup_app():
    app = Flask(__name__)
    app.register_blueprint(dashboard_bp)
    return app.test_client()


def test_get_dashboard_stats(monkeypatch):

    class FakeQuery:
        def __init__(self, value):
            self.value = value

        def scalar(self):
            return self.value

    # Фейковый session.query
    class FakeSession:
        def query(self, arg):
            text = str(arg).lower()

            if "sum" in text:
                return FakeQuery(12345)

            if "guest" in text:
                return FakeQuery(10)

            if "booking" in text:
                return FakeQuery(5)

            return FakeQuery(0)

    monkeypatch.setattr(dashboard_module.db, "session", FakeSession())

    client = setup_app()
    response = client.get("/api/dashboard/stats")

    assert response.status_code == 200
    assert response.json == {
        "total_guests": 10,
        "total_bookings": 5,
        "total_revenue": 12345.0
    }

№4 test_hotels_routes.py

from flask import Flask
from app.routes.hotels import hotels_bp
import app.routes.hotels as hotels_module


def setup_app():
    app = Flask(__name__)
    app.register_blueprint(hotels_bp)
    return app.test_client()


def test_get_hotels_basic(monkeypatch):

    class FakeHotel:
        def to_dict(self):
            return {"id": 1, "name": "Test Hotel"}

    class FakeQuery:
        def all(self):
            return [FakeHotel()]

    class FakeHotelModel:
        query = FakeQuery()
        city = None
        star_rating = None

    monkeypatch.setattr(hotels_module, "Hotel", FakeHotelModel)

    client = setup_app()
    response = client.get("/api/hotels/")

    assert response.status_code == 200
    assert response.json == [{"id": 1, "name": "Test Hotel"}]

def test_get_hotels_filter_location(monkeypatch):

    class FakeField:
        def ilike(self, value):
            return f"ILIKE({value})"

    class FakeHotel:
        def to_dict(self):
            return {"id": 2, "name": "City Hotel"}

    class FakeQuery:
        def filter(self, *args, **kwargs):
            return self
        def all(self):
            return [FakeHotel()]

    class FakeHotelModel:
        city = FakeField()
        star_rating = FakeField()
        query = FakeQuery()

    monkeypatch.setattr(hotels_module, "Hotel", FakeHotelModel)

    client = setup_app()
    response = client.get("/api/hotels/?location=City")

    assert response.status_code == 200
    assert response.json == [{"id": 2, "name": "City Hotel"}]

def test_get_hotels_filter_rating(monkeypatch):

    class FakeField:
        def __ge__(self, other):
            return f">={other}"

    class FakeHotel:
        def to_dict(self):
            return {"id": 3, "name": "Luxury Hotel"}

    class FakeQuery:
        def filter(self, *args, **kwargs):
            return self
        def all(self):
            return [FakeHotel()]

    class FakeHotelModel:
        city = FakeField()
        star_rating = FakeField()
        query = FakeQuery()

    monkeypatch.setattr(hotels_module, "Hotel", FakeHotelModel)

    client = setup_app()
    response = client.get("/api/hotels/?min_rating=4.5")

    assert response.status_code == 200
    assert response.json == [{"id": 3, "name": "Luxury Hotel"}]


def test_get_hotel_success(monkeypatch):

    class FakeHotel:
        def to_dict(self):
            return {"id": 10, "name": "Resort Hotel"}

    class FakeQuery:
        @staticmethod
        def get_or_404(id):
            return FakeHotel()

    class FakeHotelModel:
        query = FakeQuery()
        city = None
        star_rating = None

    monkeypatch.setattr(hotels_module, "Hotel", FakeHotelModel)

    client = setup_app()
    response = client.get("/api/hotels/10")

    assert response.status_code == 200
    assert response.json == {"id": 10, "name": "Resort Hotel"}


def test_get_hotel_not_found(monkeypatch):

    from werkzeug.exceptions import NotFound

    class FakeQuery:
        @staticmethod
        def get_or_404(id):
            raise NotFound()

    class FakeHotelModel:
        query = FakeQuery()
        city = None
        star_rating = None

    monkeypatch.setattr(hotels_module, "Hotel", FakeHotelModel)

    client = setup_app()
    response = client.get("/api/hotels/999")

    assert response.status_code == 404

№5 test_main_about_routes.py

import json
import builtins
from flask import Flask
from app.routes.main import main_bp
import app.routes.main as main_module


def test_about_success(monkeypatch):
    
    fake_data = {"project": "Test Project"}

    def fake_open(*args, **kwargs):
        class FakeFile:
            def __enter__(self):
                return self
            def __exit__(self, *exc):
                pass
            def read(self):
                return json.dumps(fake_data)
        return FakeFile()

    monkeypatch.setattr(builtins, "open", fake_open)

    def fake_render_template(template_name, project):
        return f"ABOUT: {project['project']}"

    monkeypatch.setattr(main_module, "render_template", fake_render_template)

    app = Flask(__name__)
    app.register_blueprint(main_bp)

    client = app.test_client()
    response = client.get("/about")

    assert response.status_code == 200
    assert b"ABOUT: Test Project" in response.data

📄Templates test📄

№1 test__init__.py

from flask import Flask
from app import create_app
import app.extensions as extensions
from app.routes.auth import auth
from app.routes.hotels import hotels_bp
from app.routes.api import api_bp
from app.routes.dashboard import dashboard_bp
from app.routes.main import main_bp


def test_create_app(monkeypatch):
    

    init_called = {"value": False}
    create_all_called = {"value": False}

    def fake_init_app(app):
        init_called["value"] = True

    monkeypatch.setattr(extensions.db, "init_app", fake_init_app)

    def fake_create_all():
        create_all_called["value"] = True

    monkeypatch.setattr(extensions.db, "create_all", fake_create_all)

    app = create_app()

    assert isinstance(app, Flask)

    assert "auth" in app.blueprints
    assert "hotels" in app.blueprints
    assert "api" in app.blueprints
    assert "dashboard" in app.blueprints
    assert "main" in app.blueprints

    assert init_called["value"] is True
    assert create_all_called["value"] is True

№2 test_config.py

import os
from app.config import Config


def test_config_env_loading(monkeypatch):

    monkeypatch.setenv("USER", "test_user")
    monkeypatch.setenv("PASSWORD", "test_pass")
    monkeypatch.setenv("HOST", "test_host")
    monkeypatch.setenv("PORT", "9999")
    monkeypatch.setenv("DB", "test_db")
    monkeypatch.setenv("SECRET_KEY", "secret123")
    monkeypatch.setenv("JWT_SECRET_KEY", "jwt123")

    from importlib import reload
    import app.config as config_module
    reload(config_module)
    Config = config_module.Config

    assert Config.USER == "test_user"
    assert Config.PASSWORD == "test_pass"
    assert Config.HOST == "test_host"
    assert Config.PORT == "9999"
    assert Config.DB == "test_db"
    assert Config.SECRET_KEY == "secret123"
    assert Config.JWT_SECRET_KEY == "jwt123"

    assert Config.SQLALCHEMY_DATABASE_URI == (
        "postgresql+psycopg2://postgres:2211@localhost:5432/cristofbooking?sslmode=disable"
    )

    assert Config.SQLALCHEMY_TRACK_MODIFICATIONS is True

№3 test_extensions.py

import pytest
from flask import Flask
from app.extensions import db


def test_db_initialization():
    app = Flask(__name__)
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///:memory:"
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.init_app(app)

    with app.app_context():
        try:
            db.create_all()
        except Exception as e:
            pytest.fail(f"db.create_all() вызвал ошибку: {e}")

    assert True

