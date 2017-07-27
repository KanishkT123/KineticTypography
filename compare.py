from scipy.spatial import distance as dist
import matplotlib.pyplot as plt
import numpy as np
import argparse
import glob
import cv2


def sumValue(image, xMin, yMin, xMax, yMax):
    height = len(image)
    width = len(image[0])
    totalPix = height * width

    blue = 0
    green = 0
    red = 0

    for row in range(yMin, yMax + 1):
        for col in range(xMin, xMax):
            pixel = image[row][col]

            blueVal = pixel[0]
            greenVal = pixel[1]
            redVal = pixel[2]

            blue += blueVal
            green += greenVal
            red += redVal

    blue = blue/totalPix
    green = green/totalPix
    red = red/totalPix

    return blue, green, red


def segment(imagePath, xMin, yMin, xMax, yMax):
    # The coordinates are for the textbox

    image = cv2.imread(imagePath)
    numSplit = 20

    width = xMax - xMin
    splitWidth = width // numSplit
    leftLine = xMin # Initial value of left
    blueList = []
    greenList = []
    redList = []

    for rightLine in range(xMin + splitWidth, xMax, splitWidth):
        blue, green, red = sumValue(image, leftLine, yMin, rightLine, yMax)

        blueList.append(blue)
        greenList.append(green)
        redList.append(red)
    
    x = range(len(blueList))

    plt.plot(x, blueList, color = "b")
    plt.show()