from flask import Blueprint, render_template, jsonify
import json

main_bp = Blueprint('main', __name__)

@main_bp.route('/about')
def about():
    try:
        with open('about.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
        return render_template('about.html', project=data)
    except Exception as e:
        return f"Error loading about page: {str(e)}", 500
