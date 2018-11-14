from __future__ import print_function
import sys
import cv2
import argparse
from random import randint
from letterBox import getRectCoords



# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-v", "--video", type=str,
    help="path to input video file")
ap.add_argument("-f", "--frame", type=str, 
    help="path to initial frame")
ap.add_argument("-c", "--colors", type=int, 
    help="number of colors")
args = vars(ap.parse_args())


# initialize CSRT tracker
tracker = cv2.TrackerCSRT_create()

# Create a video capture object to read videos
cap = cv2.VideoCapture(args["video"])
 
# Read first frame
success, frame = cap.read()
# quit if unable to read the video file
if not success:
    print('Failed to read video')
    sys.exit(1)

## Select boxes
bboxes = []
colors = [] 
count = 0

imagePath = args["frame"]
numClusters = args["colors"]
bboxes = getRectCoords(imagePath, numClusters)
 

for box in bboxes:
    colors.append((randint(0, 255), randint(0, 255), randint(0, 255)))

 
print('Selected bounding boxes {}'.format(bboxes))


# Specify the tracker type
trackerType = "CSRT"   
 
# Create MultiTracker object
multiTracker = cv2.MultiTracker_create()
 
# Initialize MultiTracker 
for bbox in bboxes:
    multiTracker.add(cv2.TrackerCSRT_create(), frame, bbox)


# Process video and track objects
while cap.isOpened():
    success, frame = cap.read()

    if frame is None or not success:
        break
   
    # get updated location of objects in subsequent frames
    success, boxes = multiTracker.update(frame)
 
    # draw tracked objects
    for i, newbox in enumerate(boxes):
        p1 = (int(newbox[0]), int(newbox[1]))
        p2 = (int(newbox[0] + newbox[2]), int(newbox[1] + newbox[3]))
        cv2.rectangle(frame, p1, p2, colors[i], 2, 1)
 
    # show frame
    # cv2.imwrite('mult_dumble/MultiTracker.jpg', frame)
    
    cv2.imwrite("mult_dumble2/frame%05d.jpg" % count, frame)
    count += 1

    if count % 50 == 0:
        print("on frame", count)
 
    # quit on ESC button
    if cv2.waitKey(1) & 0xFF == 27:  # Esc pressed
        break


# python3 multiTracking.py -v cutDumble.mp4 -f moveFrames/thumb0001.png -c 2