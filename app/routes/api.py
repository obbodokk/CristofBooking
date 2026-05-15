from flask import Blueprint, jsonify, request
import json
import hashlib
import os
from ..models import Room, Booking, Amenity
from ..extensions import db
import jwt
from ..models import Guest
api_bp = Blueprint('api', __name__, url_prefix='/api')

@api_bp.route('/hotels/<int:hotel_id>/rooms', methods=['GET'])
def get_rooms(hotel_id):
    rooms = Room.query.filter_by(hotel_id=hotel_id).all()
    return jsonify([room.to_dict() for room in rooms])

@api_bp.route('/amenities', methods=['GET'])
def get_amenities():
    amenities = Amenity.query.all()
    return jsonify([amenity.to_dict() for amenity in amenities])

@api_bp.route('/bookings', methods=['POST'])
def create_booking():
    token = request.headers.get("Authorization", "").replace("Bearer ", "")

    if not token:
        return jsonify({"error": "No token"}), 401

    try:
        payload = jwt.decode(
            token,
            "JWT_SECRET_KEY",
            algorithms=["HS256"]
        )
        user_id = payload["user_id"]
    except:
        return jsonify({"error": "Invalid token"}), 401

    data = request.get_json()

    try:
        new_booking = Booking(
            user_id=user_id,  
            hotel_id=data['hotel_id'],
            room_id=data.get('room_id'),
            check_in_date=data['check_in'],
            check_out_date=data['check_out'],
            total_price=data['total_price'],
            number_of_guests=data.get("number_of_guests")
        )

        db.session.add(new_booking)
        db.session.commit()

        return jsonify({"message": "ok"}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@api_bp.route('/users/<int:user_id>/bookings', methods=['GET'])
def get_user_bookings(user_id):
    bookings = Booking.query.filter_by(user_id=user_id).all()
    return jsonify([booking.to_dict() for booking in bookings])

@api_bp.route('/guests', methods=['GET'])
def get_guests():
    guests = Guest.query.all()
    return jsonify([guest.to_dict() for guest in guests])

@api_bp.route('/about', methods=['GET'])
def get_about_json():
    try:
        with open('about.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
        return jsonify(data)
    except FileNotFoundError:
        return jsonify({"error": "about.json not found"}), 404

@api_bp.route('/hash/<string:input_str>', methods=['GET'])
def get_hash(input_str):
    hash_object = hashlib.sha256(input_str.encode())
    hex_dig = hash_object.hexdigest()
    return jsonify({
        "input": input_str,
        "hash": hex_dig,
        "algorithm": "sha256"
    })