from ..extensions import db
from datetime import datetime

class Review(db.Model):
    __tablename__ = 'reviews'
    review_id = db.Column(db.Integer, primary_key=True)
    hotel_id = db.Column(db.Integer, db.ForeignKey('hotels.hotel_id'), nullable=False)
    guest_id = db.Column(db.Integer, db.ForeignKey('guests.guest_id'), nullable=False)
    booking_id = db.Column(db.Integer, db.ForeignKey('bookings.booking_id'))
    rating = db.Column(db.Integer, nullable=False)
    title = db.Column(db.String(255))
    comment = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    hotel = db.relationship('Hotel', backref=db.backref('reviews', lazy=True))
    guest = db.relationship('Guest', backref=db.backref('reviews', lazy=True))

    def to_dict(self):
        return {
            'id': self.review_id,
            'hotel_id': self.hotel_id,
            'guest_id': self.guest_id,
            'rating': self.rating,
            'title': self.title,
            'comment': self.comment,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
