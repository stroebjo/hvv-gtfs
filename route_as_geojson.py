from argparse import ArgumentParser

import MySQLdb
import MySQLdb.cursors as cursors
from geojson import Feature, FeatureCollection, Point, dump, LineString
import pandas as pd


# Parse arguments of import
parser = ArgumentParser()
parser.add_argument("-r", "--route_short_name", dest="route", required=True,
                    help="search for route where route_short name matches ROUTE", metavar="ROUTE")
parser.set_defaults(mongodb=True)
args = parser.parse_args()

# connect to database
db = MySQLdb.connect(host="127.0.0.1",user="gtfs",
                  passwd="secret",db="gtfs", port=3306,
                  cursorclass=cursors.DictCursor)
c = db.cursor()

# search for route
c.execute("""SELECT * FROM routes WHERE route_short_name = %s""", (args.route, ))
route = c.fetchone()

if route == None:
    print("No route found with route_short_name=`{}'".format(args.route))
    exit()

route_id = route['route_id']

# get stops
sql = """SELECT DISTINCT *
FROM stops
WHERE stop_id IN(
    (SELECT DISTINCT stops.parent_station
    FROM trips
    INNER JOIN stop_times ON stop_times.trip_id = trips.trip_id
    INNER JOIN stops ON stops.stop_id = stop_times.stop_id
    WHERE route_id = %s)
) AND stops.location_type='1'"""
c.execute(sql, (route_id, ))
stops = c.fetchall()

list_stops  = []
geo_stops = []
for stop in stops:
    geo_stops.append(Feature(
        geometry=Point((float(stop['stop_lon']), float(stop['stop_lat']))),
        properties={
            'name': stop['stop_name'],
            'stop_id': stop['stop_id']
        }
    ))

    list_stops.append({
        'name': stop['stop_name'],
        'stop_id': stop['stop_id'],
        'lat': float(stop['stop_lat']),
        'lon': float(stop['stop_lon'])
    })

collection_stops = FeatureCollection(geo_stops)

df_stops = pd.DataFrame(list_stops)
df_stops.to_csv("{}.csv".format(args.route), index=False)

# shapes
c.execute("""SELECT shape_id, COUNT(*) count FROM trips WHERE route_id = %s  GROUP BY shape_id ORDER BY count DESC""", (route_id, ))
trips = c.fetchall()

for trip in trips:
    shape_id = trip['shape_id']
    print(shape_id)

    c.execute("""SELECT * FROM shapes WHERE shape_id = %s ORDER BY shape_pt_sequence ASC""", (shape_id, ))
    sequence = c.fetchall()


    points = []
    for pt in sequence:
        points.append(Point((float(pt['shape_pt_lon']), float(pt['shape_pt_lat']))))

    linestring = Feature(
        geometry=LineString(points),
        properties={
            'name': args.route
        }
    )
    features = geo_stops.copy()
    features.append(linestring)
    feature_collection = FeatureCollection(features)

    with open("{}_{}.geojson".format(args.route, shape_id), "w") as f:
        dump(feature_collection, f, indent=2)
