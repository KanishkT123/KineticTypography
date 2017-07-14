from scipy.spatial import distance as dist
import matplotlib.pyplot as plt
import numpy as np
import argparse
import glob
import cv2
from histogram import histDict


images, index = histDict()
lenInd = len(index)

# METHOD #1: UTILIZING OPENCV
# initialize OpenCV methods for histogram comparison
OPENCV_METHODS = (
	("Correlation", cv2.HISTCMP_CORREL),
	("Chi-Squared", cv2.HISTCMP_CHISQR),
	("Intersection", cv2.HISTCMP_INTERSECT), 
	("Hellinger", cv2.HISTCMP_BHATTACHARYYA))
 

compareBox = index[("000636.png", 0)]
compImage = "./TextBoxes/examples/img/000636.png"
# loop over the comparison methods
for (methodName, method) in OPENCV_METHODS:
	# initialize the results dictionary and the sort
	# direction
    results = {}
    reverse = False
 
	# if we are using the correlation or intersection
	# method, then sort the results in reverse order
    if methodName in ("Correlation", "Intersection"):
        reverse = True
 
    for (key, hist) in list(index.items()):
        # compute the distance between the two histograms
        # using the method and update the results dictionary
        distance = cv2.compareHist(compareBox, hist, method)
        results[key] = distance
        
    # sort the results
    results = sorted([(value, key) for (key, value) in results.items()], reverse = reverse)

    # show the query image
    fig = plt.figure("Query")
    axes = fig.add_subplot(1, 1, 1)
    axes.imshow(images["000636.png"])
    plt.axis("off")

    # initialize the results figure
    fig = plt.figure("Results: %s" % (methodName))
    fig.suptitle(methodName, fontsize = 20)

    # loop over the results
    for (index, (value, key)) in enumerate(results):
        # show the result
        axes = fig.add_subplot(1, lenInd, index + 1)
        axes.set_title("%s: %.2f" % (key, value))
        keyName = key[0]
        plt.imshow(images[keyName])
        plt.axis("off")

# show the OpenCV methods
plt.show()