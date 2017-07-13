""" Things we want to be able to analyze:

    Font Size, font color, appearances
"""


""" Gets height of textboxes

    input: yMin, yMax
"""
def getSize(yMin, yMax):
    return yMax - yMin

""" Returns value by which the text has changed size, or 1 if the size has stayed the same

    ASSUMPTION: assume that if a word scales, it scales evenly, in both X and Y directions

    input: xMin1, xMax1, xMin2, xMax2
"""
def scale(xMin1, xMax1, xMin2, xMax2):
    width1 = xMax1 - xMin1
    width2 = xMax2 - xMin2

    return width2/width1 

""" images: source arrays, same size, same depth
    nimages: number of source images
    channels: list of the dims channels used to compute the histogram
    mask
"""
import cv2
import numpy as np
from matplotlib import pyplot as plt


def colorHist(image):
    img = cv2.imread(image)
    # hist = cv2.calcHist([img], [0], None, [256], [0, 256])

    color = ('b','g','r')
    for i,col in enumerate(color):
        histr = cv2.calcHist([img],[i],None,[256],[0,256])
        plt.plot(histr,color = col)
        plt.xlim([0,256])
    plt.show()

# colorHist(image)


image = "./frames/000636.png"

xMin = 30
xMax = 471
yMin = 57
yMax = 248

""" Color histogram with a mask
"""

def maskedHist(image, xMin, yMin, xMax, yMax):

    img = cv2.imread(image)

    # create a mask
    mask = np.zeros(img.shape[:2], np.uint8)
    mask[yMin:yMax, xMin:xMax] = 255
    masked_img = cv2.bitwise_and(img,img,mask = mask)

    color = ('b','g','r')
    for i,col in enumerate(color):
        hist_mask = cv2.calcHist([img],[i],mask,[256],[0,256])
        plt.subplot(121), plt.plot(hist_mask,color = col)
        plt.xlim([0,256])
    plt.subplot(122), plt.imshow(masked_img)
    # plt.subplot(222), plt.plot(hist_mask)
    plt.show()
    

maskedHist(image, xMin, yMin, xMax, yMax)