from app import create_app, db
from app.models import Hotel

app = create_app()

def seed_safe():
    with app.app_context():
        db.create_all()

        if Hotel.query.first() is None:
            db.session.commit()

if __name__ == "__main__":
    seed_safe()
