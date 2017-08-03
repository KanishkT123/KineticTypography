import cv2
import numpy as np
from cv2 import boundingRect, countNonZero, cvtColor, drawContours, findContours, getStructuringElement, imread, morphologyEx, pyrDown, rectangle, threshold
from PIL import Image
import statistics

image_path = "./images/frame520.jpg"

rgb = imread(image_path)
# downsample and use it for processing
# Image.fromarray(rgb).show()
# apply grayscale
small = cvtColor(rgb, cv2.COLOR_BGR2GRAY)
# morphological gradient
morph_kernel = getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
grad = morphologyEx(small, cv2.MORPH_GRADIENT, morph_kernel)
# binarize
_, bw = threshold(src=grad, thresh=0, maxval=255, type=cv2.THRESH_BINARY+cv2.THRESH_OTSU)
morph_kernel = getStructuringElement(cv2.MORPH_ELLIPSE, (16, 4))
# connect horizontally oriented regions
connected = morphologyEx(bw, cv2.MORPH_CLOSE, morph_kernel)
mask = np.zeros(bw.shape, np.uint8)
# find contours
im2, contours, hierarchy = findContours(connected, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)
# filter contours
#find median and standard deviation of heights
rectList = [boundingRect(contours[idx]) for idx in range(0,len(hierarchy[0]))]
heightList = [rect[2] for rect in rectList]
widthList = [rect[1] for rect in rectList]
medianHeight = statistics.mean(heightList)
devHeight = statistics.stdev(heightList)
medianWidth = statistics.mean(widthList)
devWidth = statistics.stdev(widthList)
for idx in range(0,len(rectList)):
	rect = x, y, rect_width, rect_height = rectList[idx]
	# fill the contour
	mask = drawContours(mask, contours, idx, (255, 255, 255), cv2.FILLED)
	# ratio of non-zero pixels in the filled region
	r = float(countNonZero(mask)) / (rect_width * rect_height)
	if r > 0.45 and rect_height > medianHeight - devHeight and rect_width > medianWidth - devWidth:
		rgb = rectangle(rgb, (x, y+rect_height), (x+rect_width, y), (255,255,255),3)


Image.fromarray(rgb).show()