from ..extensions import db
from datetime import datetime

class Booking(db.Model):
    __tablename__ = 'bookings'

    booking_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    hotel_id = db.Column(db.Integer, db.ForeignKey('hotels.hotel_id'), nullable=False)
    room_id = db.Column(db.Integer, db.ForeignKey('rooms.room_id'), nullable=True)

    check_in_date = db.Column(db.Date, nullable=False)
    check_out_date = db.Column(db.Date, nullable=False)

    total_price = db.Column(db.Numeric(10, 2), nullable=False)
    status = db.Column(db.String(50), default='pending')

    booked_at = db.Column(db.DateTime, default=datetime.utcnow)

    number_of_guests = db.Column(db.Integer, nullable=False)

    user = db.relationship('User', backref='bookings', lazy=True)
    hotel = db.relationship('Hotel', backref='bookings', lazy=True)
    room = db.relationship('Room', backref='bookings', lazy=True)

    def to_dict(self):
        return {
            "id": self.booking_id,
            "hotel_name": self.hotel.hotel_name if self.hotel else None,
            "room_type": self.room.room_type if self.room else None,

            "check_in": self.check_in_date.isoformat() if self.check_in_date else None,
            "check_out": self.check_out_date.isoformat() if self.check_out_date else None,

            "total_price": float(self.total_price),
            "status": self.status,
            "booked_at": self.booked_at.isoformat() if self.booked_at else None,
        }
