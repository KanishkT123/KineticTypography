# USAGE
# python object_tracker.py --prototxt deploy.prototxt --model res10_300x300_ssd_iter_140000.caffemodel

# import the necessary packages
from centroidtracker import CentroidTracker
from letterBox import getRectCoords
from random import randint
# from skvideo import VideoWriter
import numpy as np
import argparse
import imutils
import time
import cv2
import csv
import datetime


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
fps = cap.get(5)
# writer = VideoWriter("outpy.avi", frameSize=(frame_width, frame_height))
# writer.open()

dt = datetime.datetime.now().strftime("%Y-%m-%d")
csvPath = "tracking_results" + dt + ".csv" 

# Define the codec and create VideoWriter object.The output is stored in 'outpy.avi' file.
# out = cv2.VideoWriter('outpy.avi',cv2.VideoWriter_fourcc('M','J','P','G'), fps, (frame_width, frame_height))

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
# bboxes, textOCR, colors = getRectCoords(frame, [])
lifespanFile = "lifespan_" + dt + ".txt"

with open(csvPath, "w") as csv_file: # open csv writer
    writer = csv.writer(csv_file, delimiter=',') 
    avoid = []

    # loop over the frames from the video stream
    while cap.isOpened():
        # read the next frame from the video stream
        success, frame = cap.read()
        # if frame == None:
        #     break
        frame = imutils.resize(frame, width=800)

        if frame is None or not success:
            break

        # if the frame dimensions are None, grab them
        if W is None or H is None:
            (H, W) = frame.shape[:2]

        if count == 0:
            outname = "out" + dt + ".avi"
            out = cv2.VideoWriter(outname, cv2.VideoWriter_fourcc('M','J','P','G'), fps, (W, H))

        # get detections
        detections, texts, colors = getRectCoords(frame, avoid)
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
            # print(rects)
            objects, avoid, lifespan = ct.update(rects, texts, colors)

            averageLifespan = sum(lifespan)/len(lifespan)
            minLifespan = min(lifespan)
            maxLifespan = max(lifespan)

            with open(lifespanFile, "a") as text_file:
                text_file.write("Frame %s Average: %s" % (count, averageLifespan)
                text_file.write("Frame %s Minimum: %s" % (count, minLifespan)
                text_file.write("Frame %s Maximum: %s" % (count, maxLifespan)

            # loop over the tracked objects
            for (objectID, letter) in objects.items():
                centroid = letter.centroid
                color = letter.color
                text = letter.text
                lettId = letter.objectID
                info = [lettId, text, color]
                # print(info)

                # draw both the ID of the object and the centroid of the
                # object on the output frame

                # text = "ID {}".format(objectID)
                textBox = "Letter {}".format(text)
                cv2.putText(frame, textBox, (centroid[0] - 10, centroid[1] - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
                cv2.circle(frame, (centroid[0], centroid[1]), 4, (0, 255, 0), -1)

                writer.writerow(info)

            # show the output frame
            # cv2.imwrite("maps_detect2/frame%04d.png" % count, frame)
            
            # Write the frame into the file 'output.avi'
            cv2.imwrite("TEST_Frame.png", frame)
            # writer.write(frame)

            out.write(frame)
            count += 1

    writer.close()

# When everything done, release the video capture and video write objects
cap.release()
out.release()