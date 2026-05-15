from flask import Blueprint, jsonify, request
from ..models.hotel import Hotel
from ..extensions import db

hotels_bp = Blueprint('hotels', __name__, url_prefix='/api/hotels')

@hotels_bp.route('/', methods=['GET'])
def get_hotels():
    location = request.args.get('location')
    min_rating = request.args.get('min_rating', type=float)

    query = Hotel.query

    if location:
        query = query.filter(Hotel.city.ilike(f'%{location}%'))
    if min_rating:
        query = query.filter(Hotel.star_rating >= min_rating)

    hotels = query.all()
    return jsonify([hotel.to_dict() for hotel in hotels])

@hotels_bp.route('/<int:hotel_id>', methods=['GET'])
def get_hotel(hotel_id):
    hotel = Hotel.query.get_or_404(hotel_id)
    return jsonify(hotel.to_dict())
