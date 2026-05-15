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

    user = db.relationship('User', backref=db.backref('bookings', lazy=True))
    hotel = db.relationship('Hotel', backref=db.backref('bookings', lazy=True))
    room = db.relationship('Room', backref=db.backref('bookings', lazy=True))

    def to_dict(self):
        return {
            'id': self.booking_id,
            'user_id': self.user_id,
            'hotel_id': self.hotel_id,
            'room_id': self.room_id,
            'check_in': self.check_in_date.isoformat() if self.check_in_date else None,
            'check_out': self.check_out_date.isoformat() if self.check_out_date else None,
            'total_price': float(self.total_price) if self.total_price else 0,
            'status': self.status,
            'booked_at': self.booked_at.isoformat() if self.booked_at else None
        }
