from dotenv import load_dotenv
import os

class Config(object):
    load_dotenv()
    
    USER = os.getenv("USER", "postgres")
    PASSWORD = os.getenv("PASSWORD", "1234")
    HOST = os.getenv("HOST", "localhost")
    PORT = os.getenv("PORT", "5432")
    DB = os.getenv("DB", "cristofbooking")
    SECRET_KEY = os.getenv("SECRET_KEY", "key")
    SQLALCHEMY_DATABASE_URI ="postgresql+psycopg2://postgres:1234@localhost:5432/cristofbooking?sslmode=disable"
    SQLALCHEMY_TRACK_MODIFICATIONS = True
    STRIPE_SECRET_KEY = "test_key"
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")