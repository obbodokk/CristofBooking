from flask import Blueprint, jsonify
from ..extensions import db
from ..models import Guest, Booking
from sqlalchemy import func

dashboard_bp = Blueprint(
    "dashboard",
    __name__,
    url_prefix="/api/dashboard"
)

@dashboard_bp.route("/stats", methods=["GET"])
def get_dashboard_stats():
    total_guests = db.session.query(
        func.count(Guest.guest_id)
    ).scalar()

    total_bookings = db.session.query(
        func.count(Booking.booking_id)
    ).scalar()

    total_revenue = db.session.query(
        func.coalesce(func.sum(Booking.total_price), 0)
    ).scalar()

    return jsonify({
        "total_guests": total_guests,
        "total_bookings": total_bookings,
        "total_revenue": float(total_revenue)
    })