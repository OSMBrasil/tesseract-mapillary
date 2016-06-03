import re
import sys

import time
import datetime

import gpxpy
import gpxpy.gpx

from os import listdir
from os.path import isfile, join
from math import radians, cos, sin, asin, sqrt

numbers = re.compile(r'(\d+)')

n = sys.argv[1]
start = sys.argv[2]

print datetime.datetime(2016,2,3, 5, 2, 1).strftime("%Y-%m-%dT%H:%M:%S")
d = datetime.datetime.strptime(start, "%Y-%m-%dT%H:%M:%S")

print d
d += datetime.timedelta(0, 2)
print d
print n
print start

def fileNumber(value):
    parts = numbers.split(value)
    parts[1::2] = map(int, parts[1::2])
    return parts[1]

def haversine(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance between two points
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    # haversine formula
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    km = 6367 * c
    return km

mypath = '1/coord'
onlyfiles = [f for f in listdir(mypath) if (isfile(join(mypath, f)) and f.endswith('.txt'))]
onlyfiles = sorted(onlyfiles, key=fileNumber)

ptn = re.compile('-\d\d,\d\d\d\d')

lastlat = 0
lastlng = 0
lastidx = 0

def writeexif(file, date, lat, lng):
    print '{}\t{}\t{}\t{}\t'.format(f, date, lat, lng)

gpx = gpxpy.gpx.GPX()

# Create first track in our GPX:
gpx_track = gpxpy.gpx.GPXTrack()
gpx.tracks.append(gpx_track)

# Create first segment in our GPX track:
gpx_segment = gpxpy.gpx.GPXTrackSegment()
gpx_track.segments.append(gpx_segment)

# Create points:

for f in onlyfiles:

    file = open(join(mypath, f), 'r')
    lat = file.readline().replace('\n', '')
    lng = file.readline().replace('\n', '')
    if (len(lat) == 8 and len(lng) == 8 and ptn.match(lat) and ptn.match(lng)):
        idx = fileNumber(f)
        timebetween = (idx - lastidx)*2;
        latf = float(lat.replace(',', '.'))
        lngf = float(lng.replace(',', '.'))
        if (lastlat != 0):
            dist = haversine(lastlat,lastlng,latf,lngf)
            speed = ((dist * 1000)/timebetween) * 3.6
            date = d + datetime.timedelta(0, idx*2)
            print '{}\t{}\t{}\t{}\t{}\t{}'.format(idx, latf, lngf, dist, timebetween, speed)

            if (speed < 150):
                gpx_segment.points.append(gpxpy.gpx.GPXTrackPoint(latf, lngf, time=date))

        lastlat = latf
        lastlng = lngf
        lastidx = idx

new_file = open('final.gpx', "w")
new_file.write(gpx.to_xml())
new_file.close()
