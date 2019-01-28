# USAGE
# python object_tracker.py --prototxt deploy.prototxt --model res10_300x300_ssd_iter_140000.caffemodel

# import the necessary packages
from centroidtracker import CentroidTracker
from letterBox import getRectCoords
from random import randint
import numpy as np
import argparse
import imutils
import time
import cv2

# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-v", "--video", type=str,
    help="path to input video file")
ap.add_argument("-c", "--colors", type=int, 
    help="number of colors")

# ap.add_argument("-p", "--prototxt", required=True,
# 	help="path to Caffe 'deploy' prototxt file")
# ap.add_argument("-m", "--model", required=True,
# 	help="path to Caffe pre-trained model")
# ap.add_argument("-c", "--confidence", type=float, default=0.5,
# 	help="minimum probability to filter weak detections")
args = vars(ap.parse_args())

# initialize our centroid tracker and frame dimensions
ct = CentroidTracker()
(H, W) = (None, None)

# # load our serialized model from disk
# print("[INFO] loading model...")
# net = cv2.dnn.readNetFromCaffe(args["prototxt"], args["model"])

# initialize the video stream and allow the camera sensor to warmup
print("[INFO] starting video stream...")
cap = cv2.VideoCapture(args["video"])
time.sleep(2.0)


# Default resolutions of the frame are obtained.The default resolutions are system dependent.
# We convert the resolutions from float to integer.
frame_width = int(cap.get(3))
frame_height = int(cap.get(4))

# Define the codec and create VideoWriter object.The output is stored in 'outpy.avi' file.
out = cv2.VideoWriter('outpy.avi',cv2.VideoWriter_fourcc('M','J','P','G'), 10, (frame_width, frame_height))

success, frame = cap.read()

# quit if unable to read the video file
if not success:
    print('Failed to read video')
    sys.exit(1)

## Select boxes
bboxes = []
# colors = [] 
count = 0

numClusters = args["colors"]
bboxes, textOCR = getRectCoords(frame)

# loop over the frames from the video stream
while cap.isOpened():
    # read the next frame from the video stream
    success, frame = cap.read()
    frame = imutils.resize(frame, width=800)

    if frame is None or not success:
        break

    # if the frame dimensions are None, grab them
    if W is None or H is None:
        (H, W) = frame.shape[:2]

    # get detections
    detections, text = getRectCoords(frame)
    rects = []
    
    if len(detections) != 0:
        # loop over the detections
        for i in range(len(detections)):
        
            # compute the (x, y)-coordinates of the bounding box for
            # the object, then update the bounding box rectangles list
            box = detections[i]
            rects.append(box)

            # draw a bounding box surrounding the object so we can
            # visualize it
            (startX, startY, endX, endY) = box
            # randColor = (randint(0, 255), randint(0, 255), randint(0, 255))
            cv2.rectangle(frame, (startX, startY), (endX, endY),
                (0, 255, 0), 2)

        # update our centroid tracker using the computed set of bounding
        # box rectangles
        objects = ct.update(rects)

        # loop over the tracked objects
        for (objectID, centroid) in objects.items():
            # draw both the ID of the object and the centroid of the
            # object on the output frame
            text = "ID {}".format(objectID)
            cv2.putText(frame, text, (centroid[0] - 10, centroid[1] - 10),
                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
            cv2.circle(frame, (centroid[0], centroid[1]), 4, (0, 255, 0), -1)

        # show the output frame
        # cv2.imwrite("maps_detect2/frame%04d.png" % count, frame)
        
        # Write the frame into the file 'output.avi'
        out.write(frame)
        count += 1

    # # if the `q` key was pressed, break from the loop
    # if key == ord("q"):
    #     break

# When everything done, release the video capture and video write objects
cap.release()
out.release()