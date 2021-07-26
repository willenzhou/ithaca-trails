from flask_sqlalchemy import SQLAlchemy
import base64
import boto3
import datetime
from io import BytesIO
from mimetypes import guess_extension, guess_type
import os
from PIL import Image
import random
import re
import string

db = SQLAlchemy()

EXTENSIONS = ["png", "gif", "jpg", "jpeg", "jpe"]
BASE_DIR = os.getcwd()
S3_BUCKET = "ithacatrails"
S3_BASE_URL = f"https://{S3_BUCKET}.s3-us-east-2.amazonaws.com"

# association table that connects multiple actiivities (Running, Hiking, etc)
# to multiple trails
association_table = db.Table(
    'association_table',
    db.Model.metadata,
    db.Column('trail_id', db.Integer, db.ForeignKey('trail.id')),
    db.Column('activity_id', db.Integer, db.ForeignKey('activity.id'))
)

# Asset (Image) table


class Asset(db.Model):
    __tablename__ = "asset"

    id = db.Column(db.Integer, primary_key=True)
    base_url = db.Column(db.String, nullable=True)
    salt = db.Column(db.String, nullable=False)
    extension = db.Column(db.String, nullable=False)
    width = db.Column(db.String, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    create_at = db.Column(db.DateTime, nullable=False)

    def __init__(self, **kwargs):
        self.create(kwargs.get("image_data"))

    def serialize(self):
        return{
            "url": f"{self.base_url}/{self.salt}.{self.extension}",
            "create_at": str(self.create_at),
        }

    def create(self, image_data):
        try:
            # base64 string ---> .png ---> png
            ext = guess_extension(guess_type(image_data)[0])[1:]
            if ext not in EXTENSIONS:
                raise Exception(f"Extension {ext} not supported!")

            # secure way of generating random string for image name
            salt = "".join(
                random.SystemRandom().choice(
                    string.ascii_uppercase + string.digits
                )
                for _ in range(16)
            )

            img_str = re.sub("^data:image/.+;base64,", "", image_data)
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            self.base_url = S3_BASE_URL
            self.salt = salt
            self.extension = ext
            self.width = img.width
            self.height = img.height
            self.create_at = datetime.datetime.now()

            img_filename = f"{salt}.{ext}"
            self.upload(img, img_filename)

        except Exception as e:
            print(f"Unable to create an image due to {e}")

    def upload(self, img, img_filename):
        try:
            # saves image temporarily on server
            img_temploc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temploc)

            # upload image to S3
            s3_client = boto3.client("s3")
            s3_client.upload_file(img_temploc, S3_BUCKET, img_filename)

            # make s3 URL public
            s3_resource = boto3.resource("s3")
            object_acl = s3_resource.ObjectAcl(S3_BUCKET, img_filename)
            object_acl.put(ACL="public-read")

            os.remove(img_temploc)

        except Exception as e:
            print(f"Unable to upload an image due to {e}")

# Review table


class Review(db.Model):
    __tablename__ = 'review'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    body = db.Column(db.String, nullable=False)
    rating = db.Column(db.Integer, nullable=False)
    username = db.Column(db.String, nullable=False)
    # user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)
    # user = db.relationship('User', back_populates='reviews') #association
    trail_id = db.Column(db.Integer, db.ForeignKey('trail.id'), nullable=False)
    trail = db.relationship('Trail', back_populates='reviews')  # association
    comments = db.relationship(
        'Comment', cascade='delete', back_populates='review')  # association
    #image_id = db.Column(db.Integer, db.ForeignKey('asset.id'))
    #image = db.relationship('Asset', backref="review")

    def __init__(self, **kwargs):
        self.title = kwargs.get('title', '')
        self.body = kwargs.get('body', '')
        self.rating = kwargs.get('rating', 1)
        self.username = kwargs.get('username', '')
        # self.user_id = kwargs.get('user_id')
        # self.user = kwargs.get('user')
        self.trail_id = kwargs.get('trail_id')
        self.trail = kwargs.get('trail')
        self.comments = []
        #self.image_id = kwargs.get('image_id', -1)
        #self.image = kwargs.get('image')

    def serialize(self):
        return {
            'id': self.id,
            'title': self.title,
            'username': self.username,
            'body': self.body,
            'rating': self.rating,
            # 'user': self.user.partial_serialize(),
            'trail': self.trail.partial_serialize(),
            'comments': [c.partial_serialize() for c in self.comments],
            # 'image': self.image.serialize()

        }

    def partial_serialize(self):
        return {
            'id': self.id,
            'title': self.title,
            'username': self.username,
            'body': self.body,
            'rating': self.rating
        }

# Comment table


class Comment(db.Model):
    __tablename__ = 'comment'
    id = db.Column(db.Integer, primary_key=True)
    body = db.Column(db.String, nullable=False)
    username = db.Column(db.String, nullable=False)
    # user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)
    # user = db.relationship('User', back_populates='comments') #association
    review_id = db.Column(db.Integer, db.ForeignKey(
        'review.id'), nullable=False)
    review = db.relationship(
        'Review', back_populates='comments')  # association

    def __init__(self, **kwargs):
        self.body = kwargs.get('body', '')
        self.username = kwargs.get('username', '')
        # self.user_id = kwargs.get('user_id')
        # self.user = kwargs.get('user')
        self.review_id = kwargs.get('review_id')
        self.review = kwargs.get('review')

    def serialize(self):
        return {
            'id': self.id,
            'body': self.body,
            'username': self.username,
            # 'user': self.user.partial_serialize(),
            'review': self.review.partial_serialize()
        }

    def partial_serialize(self):
        return {
            'id': self.id,
            'body': self.body
        }

# Trail table


class Trail(db.Model):
    __tablename__ = 'trail'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    difficulty = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    length = db.Column(db.Float, nullable=False)
    length_range = db.Column(db.String, nullable=False)
    rating = db.Column(db.Integer, nullable=False)
    reviews = db.relationship('Review', back_populates='trail')  # association
    activities = db.relationship(
        'Activity', secondary=association_table, back_populates='trails')  # association
    image_url = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.latitude = kwargs.get('latitude', 1.0)
        self.longitude = kwargs.get('longitude', 1.0)
        self.difficulty = kwargs.get('difficulty', '')
        self.description = kwargs.get('description', '')
        self.length = kwargs.get('length', 1.0)
        self.length_range = kwargs.get('length_range', '')
        self.rating = kwargs.get('rating', 0)
        self.activities = []
        self.reviews = []
        self.image_url = kwargs.get('image_url', '')

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'latitude': self.latitude,
            'longitude': self.longitude,
            'difficulty': self.difficulty,
            'description': self.description,
            'length': self.length,
            'rating': self.rating,
            'activities': [a.partial_serialize() for a in self.activities],
            'reviews': [r.partial_serialize() for r in self.reviews],
            'image_url': self.image_url
        }

    def partial_serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'latitude': self.latitude,
            'longitude': self.longitude,
            'difficulty': self.difficulty,
            'length': self.length,
            'rating': self.rating,
            'image_url': self.image_url
        }

# Activity table


class Activity(db.Model):
    __tablename__ = 'activity'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    trails = db.relationship(
        'Trail', secondary=association_table, back_populates='activities')  # association

    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.trails = []

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'trails': [t.partial_serialize() for t in self.trails]
        }

    def partial_serialize(self):
        return {
            'id': self.id,
            'name': self.name
        }

        # # User table
# class User(db.Model):
#   __tablename__ = 'user'
#   id = db.Column(db.Integer, primary_key = True)
#   first_name = db.Column(db.String, nullable = False)
#   last_name = db.Column(db.String, nullable = False)
#   username = db.Column(db.String, nullable = False)
#   password = db.Column(db.String, nullable = False)
#   reviews = db.relationship('Review', back_populates='user') #association
#   comments = db.relationship('Comment', back_populates='user') #association

#   def __init__(self, **kwargs):
#     self.first_name = kwargs.get('first_name', '')
#     self.last_name = kwargs.get('last_name', '')
#     self.username = kwargs.get('username', '')
#     self.password = kwargs.get('password', '')
#     self.reviews = []
#     self.comments = []

#   def serialize(self):
#     return {
#       'id': self.id,
#       'first_name': self.first_name,
#       'last_name': self.last_name,
#       'username': self.username,
#       'password': self.password,
#       'reviews': [r.partial_serialize() for r in self.reviews],
#       'comments': [c.partial_serialize() for c in self.comments]
#     }

#   def partial_serialize(self):
#     return {
#       'id': self.id,
#       'first_name': self.first_name,
#       'last_name': self.last_name,
#       'username': self.username
#     }
