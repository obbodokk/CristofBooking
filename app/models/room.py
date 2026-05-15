from ..extensions import db
from sqlalchemy.dialects.postgresql import ARRAY

class Room(db.Model):
    __tablename__ = 'rooms'
    room_id = db.Column(db.Integer, primary_key=True)
    hotel_id = db.Column(db.Integer, db.ForeignKey('hotels.hotel_id'), nullable=False)
    room_type = db.Column(db.String(255))
    description = db.Column(db.Text)
    max_guests = db.Column(db.Integer)
    price_per_night = db.Column(db.Numeric)
    amenities = db.Column(ARRAY(db.String))
    is_available = db.Column(db.Boolean)
    image_url = db.Column(db.String(500))

    def to_dict(self):
        return {
            'id': self.room_id,
            'hotel_id': self.hotel_id,
            'type': self.room_type,
            'price': float(self.price_per_night) if self.price_per_night else 0,
            'available': self.is_available,
            'image': self.image_url,
            'description': self.description,
            'max_guests':self.max_guests
        }
