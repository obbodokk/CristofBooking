from ..extensions import db

class Amenity(db.Model):
    __tablename__ = 'amenities'
    amenitie_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    icon_url = db.Column(db.String(255))

    def to_dict(self):
        return {
            'id': self.amenitie_id,
            'name': self.name,
            'icon_url': self.icon_url
        }
