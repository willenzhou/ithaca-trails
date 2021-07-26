Get all trails:
GET "/api/trails/"

Response:

{"success": true, "data": [{"id": 1, "name": "Abbott Loop East", "latitude": 42.2964, "longitude": -76.4858,
"difficulty": "Moderate", "description": "The Abbott Loop was planned by Cliff and Doris \nAbbott and built by the
Cayuga Trails Club. It is one of the most popular day hikes \nin our region offering a moderately challenging wilderness
loop hike of 8.2 miles. \nNumerous shorter out and back hikes can also be planned. Starting at the southern crossing of
the Abbott Loop \nand Michigan Hollow Road, cross the creek on the road and pick up the orange blazed \nAbbott Loop
Trail on the right (eastern side) of Michigan Hollow Road, opposite the wide shoulder \nparking spot. Cross a rocky
ravine and begin a steep ascent. The trail \nreaches Hill Road (south) after 0.9 miles from the start. Turn right on the
road. \nThe trail leaves the road on the left and crosses a creek (1.5 miles). \nThe orange blazed trail ends after 2
miles at a junction with the white blazed \nmain FLT. Turn left, cross an old beaver dam on puncheons and start uphill
to \nHill Road. Cross Hill Road (north) (2.2 miles). Cross a stream on a footbridge \nand reach Smiley Hill Road. Cross
Road and another footbridge. Reach Michigan \nHollow Road after 3.6 miles. This trail is NOT closed during hunting
season \nhowever hunting is permitted in Danby State Forest. Stay on trail and wear blaze \norange during hunting
seasons.", "length": 3.54, "rating": 0, "activities": [{"id": 2, "name": "Running"}, {"id": 1, "name": "Hiking"}],
"reviews": [], "image_url": "https://ithacatrails.s3-us-east-2.amazonaws.com/V8D2X2L802LMHM73.jpe"}, {"id": 2, "name":
"Black Diamond Trail", "latitude": 42.447199, "longitude": -76.515307, "difficulty": "Easy", "description": "This Rail
Trail is part of the old line that was \nonce the flagship passenger line of the Lehigh Valley Railroad. Known as the
\nBlack Diamond Express, this luxury passenger service ran from New York to \nBuffalo from 1896 until 1959.
Recreationists will experience a range of natural\n landscapes from a towering canopy of mature maple, hemlock, oak, and
hickory, \n to views of pastoral agricultural lands, and dozens of ravines with the sounds\n of cascading waters all
heading for the picturesque Cayuga Lake. This \n 8.5-mile stone-dust path along the upland slopes of Cayuga Lake makes
for \n an enjoyable family-oriented walk, bike, or even cross-country skiing \n opportunity from the city limits of
Ithaca to the 215 foot waterfall, \n Taughannock Falls.\n", "length": 8.44, "rating": 0, "activities": [{"id": 4,
"name": "Biking"}, {"id": 1, "name": "Hiking"}, {"id": 2, "name": "Running"}, {"id": 3, "name": "Skiing"}], "reviews":
[], "image_url": "https://ithacatrails.s3-us-east-2.amazonaws.com/39FZBJQU4WH29V12.jpe"}, {"id": 3, "name": "Bald Hill
Natural Area", "latitude": 42.3582992554, "longitude": -76.382598877, "difficulty": "Moderate", "description": "\nWooded
trails at Cornell Botanic Gardens Bald Hill Natural Area ascend \nportions of a very large, contiguous forested area in
the southeastern \npart of Tompkins County. Bald Hill is the only area in the Cayuga Lake \nBasin where mountain laurel
(Kalmia latifolia) is found abundantly at \nthe northern limit of its distribution. The trails here follow an old,
\nabandoned road and provide great opportunities for cross country skiing \nor snowshoeing in the winter.\n", "length":
0.73, "rating": 0, "activities": [{"id": 1, "name": "Hiking"}], "reviews": [], "image_url":
"https://ithacatrails.s3-us-east-2.amazonaws.com/DA6FXCC9YBY0BTRU.jpe"}, {"id": 4, "name": "Cayuga Nature Center",
"latitude": 42.518599, "longitude": -76.556819, "difficulty": "Easy", "description": "\nThis is primarily a connector
trail, between the Cayuga Nature Center and \nits network of trails, and the Black Diamond trail. It leads to Treetops,
\nthe outdoor animal exhibit and the lodge. Picnicking and restrooms are \navailable at the lodge - the only such
facilities along the Black Diamond Trail.\n", "length": 0.5, "rating": 0, "activities": [{"id": 1, "name": "Hiking"},
{"id": 3, "name": "Skiing"}, {"id": 2, "name": "Running"}, {"id": 4, "name": "Biking"}], "reviews": [], "image_url":
"https://ithacatrails.s3-us-east-2.amazonaws.com/IZH42TK10C98DM18.jpe"}]}



Get a specific a trail:
GET "api/trails/{id}/"

Response:

{"success": true, "data": {"id": 1, "name": "Abbott Loop East", "latitude": 42.2964, "longitude": -76.4858,
"difficulty": "Moderate", "description": "The Abbott Loop was planned by Cliff and Doris \nAbbott and built by the
Cayuga Trails Club. It is one of the most popular day hikes \nin our region offering a moderately challenging wilderness
loop hike of 8.2 miles. \nNumerous shorter out and back hikes can also be planned. Starting at the southern crossing of
the Abbott Loop \nand Michigan Hollow Road, cross the creek on the road and pick up the orange blazed \nAbbott Loop
Trail on the right (eastern side) of Michigan Hollow Road, opposite the wide shoulder \nparking spot. Cross a rocky
ravine and begin a steep ascent. The trail \nreaches Hill Road (south) after 0.9 miles from the start. Turn right on the
road. \nThe trail leaves the road on the left and crosses a creek (1.5 miles). \nThe orange blazed trail ends after 2
miles at a junction with the white blazed \nmain FLT. Turn left, cross an old beaver dam on puncheons and start uphill
to \nHill Road. Cross Hill Road (north) (2.2 miles). Cross a stream on a footbridge \nand reach Smiley Hill Road. Cross
Road and another footbridge. Reach Michigan \nHollow Road after 3.6 miles. This trail is NOT closed during hunting
season \nhowever hunting is permitted in Danby State Forest. Stay on trail and wear blaze \norange during hunting
seasons.", "length": 3.54, "rating": 0, "activities": [{"id": 2, "name": "Running"}, {"id": 1, "name": "Hiking"}],
"reviews": [], "image_url": "https://ithacatrails.s3-us-east-2.amazonaws.com/V8D2X2L802LMHM73.jpe"}}

----------CRUD for REVIEWS-------------

Get all reviews for a trail
GET "api/trails/{id}/reviews/"

Response:

{"success": true, "data": [{"id": 1, "title": "New Review 2", "username": "Alan", "body": "Body of new Review 2",
"rating": 4, "trail": {"id": 1, "name": "Abbott Loop East", "latitude": 42.2964, "longitude": -76.4858, "difficulty":
"Moderate", "length": 3.54, "rating": 0, "image_url":
"https://ithacatrails.s3-us-east-2.amazonaws.com/V8D2X2L802LMHM73.jpe"}, "comments": []}, {"id": 2, "title": "New
Review", "username": "Alan", "body": "Body of new Review", "rating": 3, "trail": {"id": 1, "name": "Abbott Loop East",
"latitude": 42.2964, "longitude": -76.4858, "difficulty": "Moderate", "length": 3.54, "rating": 0, "image_url":
"https://ithacatrails.s3-us-east-2.amazonaws.com/V8D2X2L802LMHM73.jpe"}, "comments": []}]}

Create a review:
POST "api/trails/{id}/reviews/"

Request:
{
    "title": "New Review",
    "username": "Alannnj",
    "body": "Body of new Review",
    "rating": 3
}

Response:

{"success": true, "data": {"id": 1, "title": "New Review", "username": "Alannnj", "body": "Body of new Review",
"rating": 3, "trail": {"id": 1, "name": "Abbott Loop East", "latitude": 42.2964, "longitude": -76.4858, "difficulty":
"Moderate", "length": 3.54, "rating": 0, "image_url":
"https://ithacatrails.s3-us-east-2.amazonaws.com/V8D2X2L802LMHM73.jpe"}, "comments": []}}

Delete a specific review:
DELETE "api/trails/{id}/reviews/{id}/"

Response:

{"success": true, "data": {"id": 1, "title": "New Review", "username": "Alannnj", "body": "Body of new Review",
"rating": 3, "trail": {"id": 1, "name": "Abbott Loop East", "latitude": 42.2964, "longitude": -76.4858, "difficulty":
"Moderate", "length": 3.54, "rating": 0, "image_url":
"https://ithacatrails.s3-us-east-2.amazonaws.com/V8D2X2L802LMHM73.jpe"}, "comments": []}}

Get a specific review:
GET "api/trails/{id}/reviews/{id}/"

Response:

{"success": true, "data": {"id": 1, "title": "New Review 2", "username": "Alan", "body": "Body of new Review 2",
"rating": 4, "trail": {"id": 1, "name": "Abbott Loop East", "latitude": 42.2964, "longitude": -76.4858, "difficulty":
"Moderate", "length": 3.54, "rating": 0, "image_url":
"https://ithacatrails.s3-us-east-2.amazonaws.com/V8D2X2L802LMHM73.jpe"}, "comments": []}}

Update a specific review:
POST "api/trails/{id}/reviews/{id}/update/"

Request:
{
    "title": "Newer Review",
    "username": "Alan#2",
    "body": "Body of NEWER Review",
    "rating": 5
}

Response:

{"success": true, "data": {"id": 1, "title": "Newer Review", "username": "Alan#2", "body": "Body of NEWER Review",
"rating": 5, "trail": {"id": 1, "name": "Abbott Loop East", "latitude": 42.2964, "longitude": -76.4858, "difficulty":
"Moderate", "length": 3.54, "rating": 0, "image_url":
"https://ithacatrails.s3-us-east-2.amazonaws.com/V8D2X2L802LMHM73.jpe"}, "comments": []}}

--------CRUD for Comments-------------

Get all comments for a specific review
GET "api/trails/{id}/reviews/{id}/comments/"

Responses:

{"success": true, "data": [{"id": 1, "body": "Body of Comment", "username": "Alan#2", "review": {"id": 1, "title":
"Newer Review", "username": "Alan#2", "body": "Body of NEWER Review", "rating": 5}}, {"id": 2, "body": "Body of
Commentttt", "username": "Alan#1", "review": {"id": 1, "title": "Newer Review", "username": "Alan#2", "body": "Body of
NEWER Review", "rating": 5}}]}

Get a specific comment for a specific review
GET "api/trails/{id}/reviews/{id}/comments/{id}/"

Response:

{"success": true, "data": {"id": 1, "body": "Body of Comment", "username": "Alan", "review": {"id": 1, "title": "Newer
Review", "username": "Alan", "body": "Body of newer Review", "rating": 4}}}

Create a comment for a specific review
POST "api/trails/{id}/reviews/{id}/comments/"

Request:
{
    "username": "Alan#2",
    "body": "Body of Comment"
}

Response:

{"success": true, "data": {"id": 1, "body": "Body of Comment", "username": "Alan#2", "review": {"id": 1, "title": "Newer
Review", "username": "Alan#2", "body": "Body of NEWER Review", "rating": 5}}}

Update a comment for a specific review by entering a new usermame, a new body, or both
POST "api/trails/{id}/reviews/{id}/comments/{id}/update/"

Request:
{
    "username": "NEW Alan#1",
    "body": "NEW Body of Commentttt"
}

Response:

{"success": true, "data": {"id": 1, "body": "NEW Body of Commentttt", "username": "NEW Alan#1", "review": {"id": 1,
"title": "Newer Review", "username": "Alan#2", "body": "Body of NEWER Review", "rating": 5}}}

Delete a comment for specific review

DELETE "api/trails/{id}/reviews/{id}/comments/{id}/"

Response:

{"success": true, "data": {"id": 2, "body": "Body of Commentttt", "username": "Alan#1", "review": {"id": 1, "title":
"Newer Review", "username": "Alan#2", "body": "Body of NEWER Review", "rating": 5}}}
