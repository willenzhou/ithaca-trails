import json
import os
from db import db
from db import Review, Comment, Trail, Activity, Asset
from flask import Flask
from flask import request
from preload_data import load_trail_data

app = Flask(__name__)

#Reminder: Update natue of db info saving - figure it out
db_filename = "trails.db"

#sets up the config
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

#initializes our app
db.init_app(app)
with app.app_context():
    db.create_all()
load_trail_data(app, db)


# generalized response formats
def success_response(data, code=200):
    return json.dumps({"success": True, "data": data}), code

def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code

# ----------------Trail Routes------------------
#Question: will trails have IDs that I can query through or will I only have names?

#Hello World screen
@app.route('/')
def hello():
    return "Hello World!"

# For uploading images to Ithaca Trails (reviews and pre-populated trails)
@app.route("/upload/", methods=["POST"])
def upload():
    body = json.loads(request.data)
    image_data = body.get("image_data")
    if image_data is None:
        return failure_response("No base64 URL to be found")

    asset = Asset(image_data=image_data)
    db.session.add(asset)
    db.session.commit()
    return success_response(asset.serialize(),201)

#updates rating for a given trail
# def update_rating(trail):
#     if trail.rating == 0:
#         review = Review.query.filter_by(trail_id=trail.id).first()
#         trail.rating = review.rating
#     else:
#         reviews = Review.query.filter_by(trail_id=trail.id).all()
#         tot = 0
#         count = 0
#         for r in reviews:

#     db.session.commit()

# CREATE FUNCTION FOR SORTING TRAILS BY RATING
# def sort_ratings(trail):

#FOR NOW JUST RETURNS ALL TRAILS
#returns all trails based on what the user queries
@app.route("/api/trails/")
def get_trails():
    # body = json.loads(request.data)
    # trails = Trail.query.all()
    queries = []
    # trails = Trail.query.filter_by(**body).all()
    # name = body.get('name')
    # difficulty = body.get('difficulty')
    # length = body.get('length')
    # activity = body.get('activity')
    name = request.args.get('name')
    difficulty = request.args.get('difficulty')
    activity = request.args.get('activity')
    rating = request.args.get('rating')
    length_range = request.args.get('length')
    if length_range  == "< 2":
        queries.append(Trail.length<2)
    if length_range == "2 - 5":
        queries.append(Trail.length>=2)
        queries.append(Trail.length<=5)
    if length_range == "5 - 10":
        queries.append(Trail.length>5)
        queries.append(Trail.length<=10)
    if length_range == "10+":
        queries.append(Trail.length>10)

    # trails = Trail.query.all()
    if name:
        queries.append(Trail.name==name)
    if difficulty:
        queries.append(Trail.difficulty==difficulty)
    # if length:
    #     queries.append(Trail.length==length)
    if activity:
        queries.append(Activity.name==activity)
    
    trails = Trail.query.join(Trail.activities).filter(*queries).all()


    return success_response( [t.serialize() for t in trails] )

#gets a specific trail
@app.route("/api/trails/<int:trail_id>/")
def get_trail(trail_id):
    trail = Trail.query.filter_by(id=trail_id).first()
    if trail is None:
        return failure_response('Trail not found')
    return success_response(trail.serialize()) 

@app.route("/api/trails/<int:trail_id>/", methods=["DELETE"])
def delete_trail(trail_id):
    trail = Trail.query.filter_by(id=trail_id).first()
    if trail is None:
        return failure_response('Trail not found!')

    db.session.delete(trail)
    db.session.commit()
    return success_response(trail.serialize())

# --------------------REVIEWS ROUTES----------------------------

#create a review for a given trail
@app.route("/api/trails/<int:trail_id>/reviews/", methods=["POST"])
def create_review(trail_id):
    # change to <trail>.query....etc
    trail = Trail.query.filter_by(id=trail_id).first()
    if trail is None:
        return failure_response('Trail not found!')
    body = json.loads(request.data)
    # image_data = body.get("image_data")
    # if image_data is not None:
    #     asset = Asset(image_data=image_data)
    # else:
    #     asset = Asset(image_data="data:image/png;base64,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")
    # db.session.add(asset)
    # image_id = asset.id

    new_review= Review(
        title=body.get('title'),
        body=body.get('body'), 
        rating=body.get('rating'),
        username=body.get('username'),
        trail_id=trail_id,
        trail=trail
        # image_id = image_id,
        # image=asset
    )
    if new_review.title is None or new_review.rating is None:
        return failure_response('Could not create Review for trail')
    if new_review.body is None or new_review.username is None:
        return failure_response('Could not create Review for trail')
    db.session.add(new_review)
    trail.reviews.append(new_review)
    db.session.commit()
    # update_rating(trail)
    return success_response(new_review.serialize())

#delete a review for a given trail
@app.route("/api/trails/<int:trail_id>/reviews/<int:review_id>/", methods=["DELETE"])
def delete_review(trail_id,review_id):
    trail = Trail.query.filter_by(id=trail_id,).first()
    if trail is None:
        return failure_response('Trail not found!')
    review = Review.query.filter_by(id=review_id, trail=trail).first()
    if review is None:
        return failure_response('Review not found!')
    db.session.delete(review)
    db.session.commit()
    return success_response(review.serialize())

#get all reviews for a given trail
@app.route("/api/trails/<int:trail_id>/reviews/", methods=["GET"])
def get_reviews(trail_id):
    trail = Trail.query.filter_by(id=trail_id).first()
    if trail is None:
        return failure_response('Trail not found!')    
    reviews = Review.query.filter_by(trail=trail).all()
    return success_response([r.serialize() for r in reviews])

#get a specific review for given trail
@app.route("/api/trails/<int:trail_id>/reviews/<int:review_id>/", methods=["GET"])
def get_review(trail_id,review_id):    
    trail = Trail.query.filter_by(id=trail_id).first()
    if trail is None:
        return failure_response('Trail not found!')
    review = Review.query.filter_by(id=review_id, trail=trail).first()
    if review is None:
        return failure_response('Review not found!')
    return success_response(review.serialize())

#update a specific review for given trail
@app.route("/api/trails/<int:trail_id>/reviews/<int:review_id>/update/", methods=["POST"])
def update_review(trail_id,review_id):
    trail = Trail.query.filter_by(id=trail_id).first()
    if trail is None:
        return failure_response('Trail not found!')
    review = Review.query.filter_by(id=review_id, trail=trail).first()
    if review is None:
        return failure_response('Review not found!')
    body = json.loads(request.data)
    
    title=body.get('title')
    rev_body=body.get('body')
    rating=body.get('rating')
    username=body.get('username')
    #images?? is there a way to intergrate that here??
    if title is not None:
        review.title = title
    if rev_body is not None:
        review.body = rev_body
    if rating is not None:
        review.rating = rating
    if username is not None:
        review.username = username
    db.session.commit()
    return success_response(review.serialize())


#-------------------------------COMMMENTS ROUTES--------------------------------
#get all comments from a review
@app.route("/api/trails/<int:trail_id>/reviews/<int:review_id>/comments/", methods=["GET"])
def get_comments(trail_id,review_id):    
    trail = Trail.query.filter_by(id=trail_id).first()
    if trail is None:
        return failure_response('Trail not found!')

    review = Review.query.filter_by(id=review_id, trail=trail).first()
    if review is None:
        return failure_response('Review not found!')
    comments = Comment.query.filter_by(review=review).all()
    return success_response([c.serialize() for c in comments])

# get one specific comment from a review
@app.route("/api/trails/<int:trail_id>/reviews/<int:review_id>/comments/<int:comment_id>/", methods=["GET"])
def get_comment(trail_id,review_id,comment_id):    
    trail = Trail.query.filter_by(id=trail_id,).first()
    if trail is None:
        return failure_response('Trail not found!')
    review = Review.query.filter_by(id=review_id, trail=trail).first()
    if review is None:
        return failure_response('Review not found!')
    comment = Comment.query.filter_by(id=comment_id, review=review).first()
    if comment is None:
        return failure_response('Comment not found!')
    return success_response(comment.serialize())

# create a comment
@app.route("/api/trails/<int:trail_id>/reviews/<int:review_id>/comments/", methods=["POST"])
def create_comment(trail_id,review_id):
    trail = Trail.query.filter_by(id=trail_id,).first()
    if trail is None:
        return failure_response('Trail not found!')
    review = Review.query.filter_by(id=review_id, trail=trail).first()
    if review is None:
        return failure_response('Review not found!')
    body = json.loads(request.data)

    new_comment = Comment(body=body.get('body'), username=body.get('username'), 
                          review_id=review_id, review=review)
                          
    if new_comment.body is None or new_comment.username is None:
        return failure_response('Could not create comment!')
    review.comments.append(new_comment)
    db.session.add(new_comment)
    db.session.commit()
    return success_response(new_comment.serialize(), 201)

#update a comment
@app.route("/api/trails/<int:trail_id>/reviews/<int:review_id>/comments/<int:comment_id>/update/", methods=["POST"])
def update_comment(trail_id,review_id,comment_id):
    #change this accordingly based on data base <review>...etc
    trail = Trail.query.filter_by(id=trail_id,).first()
    if trail is None:
        return failure_response('Trail not found!')
    review = Review.query.filter_by(id=review_id, trail=trail).first()
    if review is None:
        return failure_response('Review not found!')
    comment = Comment.query.filter_by(id=comment_id, review=review).first()
    if comment is None:
        return failure_response('Comment not found!')
    body = json.loads(request.data)
    com_body=body.get('body')
    username=body.get('username')
    if username is not None:
        comment.username = username
    if com_body is not None:
        comment.body = com_body  
    db.session.commit()
    return success_response(comment.serialize())

#delete a comment
@app.route("/api/trails/<int:trail_id>/reviews/<int:review_id>/comments/<int:comment_id>/", methods=["DELETE"])
def delete_comment(trail_id,review_id,comment_id):
    trail = Trail.query.filter_by(id=trail_id,).first()
    if trail is None:
        return failure_response('Trail not found!')
    review = Review.query.filter_by(id=review_id, trail=trail).first()
    if review is None:
        return failure_response('Review not found!')
    comment = Comment.query.filter_by(id=comment_id, review=review).first()
    if comment is None:
        return failure_response('Comment not found!')
    db.session.delete(comment)
    db.session.commit()
    return success_response(comment.serialize())

#--------------------USERS----------------------------------
# @app.route("/api/users/", methods=["POST"])
# def create_user():
#     body = json.loads(request.data)
#     # can change to first and last name if we want to?
#     new_user = User(name=body.get('name'), username=body.get('usernmae'))

#     if new_user.name is None or new_user.username is None:
#         return failure_response('Could not create user!')

#     db.session.add(new_user)
#     db.session.commit()
#     return success_response(new_user.serialize(), 201)

# @app.route("/api/users/<int:user_id>/")
# def get_user(user_id):
#     user = User.query.filter_by(id=user_id).first()
#     if user is None:
#         return failure_response('User not found!')
#     return success_response(user.serialize())

# # get all user comments
# @app.route("/api/trails/reviews/comments/user/<int:user_id>/", methods=["GET"])
# def get_usercomments(user_id):    
#     user = User.query.filter_by(id=user_id).first()
#     if user is None:
#         return failure_response('User not found!')
#     comments = user.comments
#     # not sure if this is what we want to serialize? Is the comments column in user just a list of commentids or a dictionary?
#     return success_response(comments.serialize())

# #get all user reviews
# # get all user comments
# @app.route("/api/trails/reviews/user/<int:user_id>/", methods=["GET"])
# def get_usercomments(user_id):    
#     user = User.query.filter_by(id=user_id).first()
#     if user is None:
#         return failure_response('User not found!')
#     reviews = user.reviews
#     # not sure if this is what we want to serialize? Is the reviews column in user just a list of reviewids or a dictionary?
#     return success_response(reviews.serialize())


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)

