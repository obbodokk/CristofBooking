from flask import Blueprint, jsonify, request
from ..models import Hotel, Room, Booking, Amenity, Review
from ..extensions import db

api_bp = Blueprint('api', __name__, url_prefix='/api')

@api_bp.route('/hotels/<int:hotel_id>/rooms', methods=['GET'])
def get_rooms(hotel_id):
    rooms = Room.query.filter_by(hotel_id=hotel_id).all()
    return jsonify([room.to_dict() for room in rooms])

@api_bp.route('/amenities', methods=['GET'])
def get_amenities():
    amenities = Amenity.query.all()
    return jsonify([amenity.to_dict() for amenity in amenities])

@api_bp.route('/hotels/<int:hotel_id>/reviews', methods=['GET'])
def get_reviews(hotel_id):
    reviews = Review.query.filter_by(hotel_id=hotel_id).all()
    return jsonify([review.to_dict() for review in reviews])

@api_bp.route('/bookings', methods=['POST'])
def create_booking():
    data = request.get_json()
    try:
        new_booking = Booking(
            user_id=data['user_id'],
            hotel_id=data['hotel_id'],
            room_id=data.get('room_id'),
            check_in_date=data['check_in'],
            check_out_date=data['check_out'],
            total_price=data['total_price']
        )
        db.session.add(new_booking)
        db.session.commit()
        return jsonify(new_booking.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400

@api_bp.route('/users/<int:user_id>/bookings', methods=['GET'])
def get_user_bookings(user_id):
    bookings = Booking.query.filter_by(user_id=user_id).all()
    return jsonify([booking.to_dict() for booking in bookings])
