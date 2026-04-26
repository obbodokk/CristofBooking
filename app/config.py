from dotenv import load_dotenv
import os

class Config(object):
    load_dotenv()
    
    USER = os.getenv("USER", "postgres")
    PASSWORD = os.getenv("PASSWORD", "")
    HOST = os.getenv("HOST", "localhost")
    PORT = os.getenv("PORT", "5432")
    DB = os.getenv("DB", "cristofbooking")
    SECRET_KEY = os.getenv("SECRET_KEY", "key")
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "jwtkey")

    SQLALCHEMY_DATABASE_URI = f'postgresql://{USER}:{PASSWORD}@{HOST}:{PORT}/{DB}'
    SQLALCHEMY_TRACK_MODIFICATIONS = True