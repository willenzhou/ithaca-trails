from db import Trail,Activity

def success_response(data, code=200):
    return json.dumps({"success": True, "data": data}), code

def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code

abott_loop_east_description = """The Abbott Loop was planned by Cliff and Doris 
Abbott and built by the Cayuga Trails Club. It is one of the most popular day hikes 
in our region offering a moderately challenging wilderness loop hike of 8.2 miles. 
Numerous shorter out and back hikes can also be planned. Starting at the southern crossing of the Abbott Loop 
and Michigan Hollow Road, cross the creek on the road and pick up the orange blazed 
Abbott Loop Trail on the right (eastern side) of Michigan Hollow Road, opposite the wide shoulder 
parking spot. Cross a rocky ravine and begin a steep ascent. The trail 
reaches Hill Road (south) after 0.9 miles from the start. Turn right on the road. 
The trail leaves the road on the left and crosses a creek (1.5 miles). 
The orange blazed trail ends after 2 miles at a junction with the white blazed 
main FLT. Turn left, cross an old beaver dam on puncheons and start uphill to 
Hill Road. Cross Hill Road (north) (2.2 miles). Cross a stream on a footbridge 
and reach Smiley Hill Road. Cross Road and another footbridge. Reach Michigan 
Hollow Road after 3.6 miles. This trail is NOT closed during hunting season 
however hunting is permitted in Danby State Forest. Stay on trail and wear blaze 
orange during hunting seasons."""

abott_loop_east_url = "https://ithacatrails.s3-us-east-2.amazonaws.com/V8D2X2L802LMHM73.jpe"

black_diamond_description = """This Rail Trail is part of the old line that was 
once the flagship passenger line of the Lehigh Valley Railroad. Known as the 
Black Diamond Express, this luxury passenger service ran from New York to 
Buffalo from 1896 until 1959. Recreationists will experience a range of natural
 landscapes from a towering canopy of mature maple, hemlock, oak, and hickory, 
 to views of pastoral agricultural lands, and dozens of ravines with the sounds
  of cascading waters all heading for the picturesque Cayuga Lake. This 
  8.5-mile stone-dust path along the upland slopes of Cayuga Lake makes for 
  an enjoyable family-oriented walk, bike, or even cross-country skiing 
  opportunity from the city limits of Ithaca to the 215 foot waterfall, 
  Taughannock Falls.
"""

black_diamond_url = "https://ithacatrails.s3-us-east-2.amazonaws.com/39FZBJQU4WH29V12.jpe"

bald_hill_description = """
Wooded trails at Cornell Botanic Gardens Bald Hill Natural Area ascend 
portions of a very large, contiguous forested area in the southeastern 
part of Tompkins County. Bald Hill is the only area in the Cayuga Lake 
Basin where mountain laurel (Kalmia latifolia) is found abundantly at 
the northern limit of its distribution. The trails here follow an old, 
abandoned road and provide great opportunities for cross country skiing 
or snowshoeing in the winter.
"""

bald_hill_url = "https://ithacatrails.s3-us-east-2.amazonaws.com/DA6FXCC9YBY0BTRU.jpe"


cayuga_nature_center_description = """
This is primarily a connector trail, between the Cayuga Nature Center and 
its network of trails, and the Black Diamond trail. It leads to Treetops, 
the outdoor animal exhibit and the lodge. Picnicking and restrooms are 
available at the lodge - the only such facilities along the Black Diamond Trail.
"""

cayuga_nature_url = "https://ithacatrails.s3-us-east-2.amazonaws.com/IZH42TK10C98DM18.jpe"


#adds a trail
def add_trail(name,length,latitude,longitude,difficulty,description,image_url):
    if length < 2.0:
        length_range = "< 2"
    elif length < 5.0:
        length_range = "2 - 5"
    elif length < 10.0:
        length_range = "5 - 10"
    else:
        length_range = "10+"

    new_trail = Trail(name=name, length=length,latitude=latitude,longitude=longitude,
      difficulty=difficulty,description=description,length_range=length_range,image_url=image_url)
    return new_trail

    # db.session.add(new_trail)
    # db.session.commit()
    # return success_response(new_trail.serialize(), 201)

#adds a trail
def add_activity(name):
    new_activity = Activity(name=name)
    return new_activity
    # db.session.add(new_activity)
    # db.session.commit()
    # return success_response(new_activity.serialize(), 201)

#adding a activity to a trail
def add_activity_to_trail(trail_id, activity_name):
  trail = Trail.query.filter_by(id=trail_id).first()
  activity = Activity.query.filter_by(name=activity_name).first()
  if trail is None:
    return failure_response("No such trail")
  if activity is None:
    return failure_response("No such activity")
  trail.activities.append(activity)
  activity.trails.append(trail)
  return "Success"

def load_trail_data(app, db):
  abbott_loop_east = add_trail("Abbott Loop East", 3.54, 42.2964, -76.4858,
  "Moderate", abott_loop_east_description, abott_loop_east_url)
  black_diamond_trail = add_trail("Black Diamond Trail", 8.44, 42.447199, -76.515307,
  "Easy", black_diamond_description, black_diamond_url)
  bald_hill_natural_area = add_trail("Bald Hill Natural Area", 0.73, 42.3582992554, 
  -76.382598877, "Moderate", bald_hill_description, bald_hill_url)
  cayuga_nature_center = add_trail("Cayuga Nature Center", 0.5, 42.518599, 
  -76.556819, "Easy", cayuga_nature_center_description, cayuga_nature_url)
  hiking = add_activity("Hiking")
  running = add_activity("Running")
  biking = add_activity("Biking")
  skiing = add_activity("Skiing")
  #db.create_all()
  with app.app_context():
    db.session.add(hiking)
    db.session.add(running)
    db.session.add(skiing)
    db.session.add(biking)
    db.session.add(abbott_loop_east)
    db.session.add(black_diamond_trail)
    db.session.add(bald_hill_natural_area)
    db.session.add(cayuga_nature_center)
    add_activity_to_trail(1, "Running")
    add_activity_to_trail(1, "Hiking")
    add_activity_to_trail(2, "Biking")
    add_activity_to_trail(2, "Hiking")
    add_activity_to_trail(2, "Running")
    add_activity_to_trail(2, "Skiing")
    add_activity_to_trail(3, "Hiking")
    add_activity_to_trail(4, "Hiking")
    add_activity_to_trail(4, "Skiing")
    add_activity_to_trail(4, "Running")
    add_activity_to_trail(4, "Biking")
    db.session.commit()