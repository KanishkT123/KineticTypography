import cv2
import os

DIRECTORY = "./videos"
for filename in os.listdir(DIRECTORY):
  newdir = DIRECTORY + "/" + filename[:10]
  newdir = newdir.replace(" ", "_")
  try:
    os.mkdir(newdir)
  except OSError as e:
    if e.errno != 17:
      raise
    continue
for filename in os.listdir(DIRECTORY):
  newdir = DIRECTORY + "/" + filename[:10]
  newdir = newdir.replace(" ", "_")
  vidcap = cv2.VideoCapture(DIRECTORY + "/" + filename, cv2.CAP_FFMPEG)
  success, image = vidcap.read()
  count = 0
  success = True
  name = filename[:10]
  while success:
      for i in range(10):
          success, image = vidcap.read()
      cv2.imwrite(newdir + "/frame_%d_%s.jpg" % (count, name), image)
      count += 1