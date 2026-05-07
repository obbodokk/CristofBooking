from ..extensions import db
from sqlalchemy.dialects.postgresql import ARRAY

class Hotel(db.Model):
    __tablename__ = 'hotels'
    hotel_id = db.Column(db.Integer, primary_key=True)
    hotel_name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)
    country = db.Column(db.String(255))
    city = db.Column(db.String(255))
    address = db.Column(db.String(255))
    star_rating = db.Column(db.Integer)
    phone = db.Column(db.String(50))
    email = db.Column(db.String(100))
    website = db.Column(db.String(255))
    amenities = db.Column(ARRAY(db.String))
    image_main_url = db.Column(db.String(500))
    image_gallery_urls = db.Column(ARRAY(db.String))
    created_at = db.Column(db.DateTime)

    def to_dict(self):
        return {
            'id': self.hotel_id,
            'name': self.hotel_name,
            'description': self.description,
            'location': f"{self.city}, {self.country}",
            'address': self.address,
            'rating': self.star_rating,
            'image_url': self.image_main_url,
            'amenities': self.amenities
        }
