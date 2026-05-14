from ..extensions import db

class Guest(db.Model):
    __tablename__ = 'guests'
    guest_id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(100), nullable=False)
    last_name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    phone = db.Column(db.String(20))
    country = db.Column(db.String(100))
    registered_at = db.Column(db.DateTime)
    def to_dict(self):
        return {
            'id': self.guest_id,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'email': self.email,
            'phone': self.phone,
            'country': self.country,
            'registered_at': self.registered_at
        }
