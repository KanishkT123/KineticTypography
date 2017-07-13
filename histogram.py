import os
import cv2
import numpy as np
from matplotlib import pyplot as plt

# ******************************************************************************************************** #
# *  The following code assumes that you are in the directory which contains the whole TextBoxes folder  * #
# *  You should also run findBoxes.py on your images FIRST before running this code                      * #
# ******************************************************************************************************** #


"""
    Goes through the results directory and returns a list of lists
    of textbox coordinates, with each separate image as an inner list
"""
def getCoordinates():
    resultsDir = "./TextBoxes/examples/results"
    picList = [] # list of coordinates of every box in a specific picture
    fileList = [] # list of image filepaths

    for root, dirs, files in os.walk(resultsDir):
        for filename in files:
            if filename != ".DS_Store":
                filePath = os.path.join(root, filename)
                coords = open(filePath, "r")
                fileList.append(filePath)
                boxList = []
                for box in coords:
                    box = box.replace("\n", "")
                    boxList.append(box)
                picList.append(boxList)
                coords.close()
    
    return fileList, picList


""" 
    Gets the list of image paths

    NOTE: These are the ACTUAL images, not the output from findBoxes.py
"""
def getImages():
    imgDir = "./TextBoxes/examples/img"
    imgList = []
    for root, dirs, files in os.walk(imgDir):
        for filename in files:
            if filename != ".DS_Store":
                filePath = os.path.join(root, filename)
                imgList.append(filePath)
    return imgList


"""
    Takes in the coordinates of the textbox and the image path and outputs a plot 
    of the masked image (only showing textbox area) and its color histogram
"""
def maskedHist(image, xMin, yMin, xMax, yMax):
    img = cv2.imread(image)

    # create a mask
    mask = np.zeros(img.shape[:2], np.uint8)
    mask[yMin:yMax, xMin:xMax] = 255 # creates a mask that leaves only the textbox area
    masked_img = cv2.bitwise_and(img,img,mask = mask) # original image with the mask over it

    color = ('b','g','r')
    for i,col in enumerate(color):
        hist_mask = cv2.calcHist([img],[i],mask,[256],[0,256])
        plt.subplot(121), plt.plot(hist_mask,color = col) # plots the histogram
        plt.xlim([0,256])
    plt.subplot(122), plt.imshow(cv2.cvtColor(masked_img, cv2.COLOR_BGR2RGB)) 
    plt.show() 


""" 
    Wrapper function
"""
def wrapper():
    fileList, picList = getCoordinates() # calls getCoordinates to get the box coordinates in a list (NOT ACTUALLY A PYTHON LIST)
    imgList = getImages()

    for i in range(len(picList)):
        image = imgList[i] # gets path of image
        coordList = picList[i] # the list of box coordinates for that image

        for box in coordList:
            box = box.split(",") # makes the string into a list
            # print(type(int(box[1])))
            xMin = int(box[1])
            yMin = int(box[2])
            xMax = int(box[3])
            yMax = int(box[4])
            maskedHist(image, xMin, yMin, xMax, yMax) # calls maskedHist on the image with all of the box coordinates

    
wrapper()