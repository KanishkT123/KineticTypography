import cv2
import argparse
import os

DIRECTORY = "./videos/MAPS"

images = []
output = "output.mp4v"

for file in os.listdir(DIRECTORY):
	if file.endswith("jpg"):
		images.append(file)

image_path = os.path.join(DIRECTORY, images[0])
frame = cv2.imread(image_path)

cv2.imshow('video', frame)
height, width, channels = frame.shape

fourcc = cv2.VideoWriter_fourcc(*'mp4v')
out = cv2.VideoWriter(output, fourcc, 20.0, (width, height))

for image in images:

    image_path = os.path.join(DIRECTORY, image)
    frame = cv2.imread(image_path)

    out.write(frame) # Write out frame to video

    cv2.imshow('video',frame)
    if (cv2.waitKey(1) & 0xFF) == ord('q'): # Hit `q` to exit
        break

# Release everything if job is finished
out.release()
cv2.destroyAllWindows()

print("The output video is {}".format(output))
