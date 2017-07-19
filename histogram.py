import os
import cv2
import numpy as np
import csv
from matplotlib import pyplot as plt

# ******************************************************************************************************** #
# *  The following code assumes that you are in the directory which contains the whole TextBoxes folder  * #
# *  You should also run findBoxes.py on your images FIRST before running this code                      * #
# ******************************************************************************************************** #



"""
    Goes through a specific directory and applies a function to every file in the directory
"""
def loopDirectory(function):
    rootDirectory = "./TextBoxes/examples/results"
    for root, dirs, files in os.walk(rootDirectory):
        for fileName in files:
            filePath = os.path.join(root, fileName)
            content = open(filePath, "r")
            function(content)
            content.close()


"""
    Takes in information and a file path and writes and saves that information as a file
"""
def saveInfo(information, fileName, filePath):
    # Writes the path to save the file
    savePath = os.path.join(filePath, fileName)

    with open(savePath, "w", newline="") as file:
        writer = csv.writer(file)
        writer.writerows(information)



"""
    Goes through the results directory and returns a list of lists
    of textbox coordinates, with each separate image as an inner list
"""
def getCoordinates():
    resultsDir = "./TextBoxes/examples/results"
    picList = [] # list of coordinates of every box in a specific picture
    fileList = [] # list of image filenames

    for root, dirs, files in os.walk(resultsDir):
        for filename in files:
            if filename != ".DS_Store":
                filePath = os.path.join(root, filename)
                coords = open(filePath, "r")
                fileList.append(filename)
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
    Takes in the coordinates of the textbox and the image path and
    saves the masked image and returns it
"""
def createMask(imagePath, xMin, yMin, xMax, yMax):
    
    # Read in the image from the image path
    image = cv2.imread(imagePath)

    # Create the mask
    mask = np.zeros(image.shape[:2], np.uint8)
    mask[yMin:yMax, xMin:xMax] = 255

    # Create masked image
    plt.figure()
    maskedImage = cv2.bitwise_and(image, image, mask = mask)
    plt.imshow(cv2.cvtColor(maskedImage, cv2.COLOR_BGR2RGB))
    # plt.figure()


    # Make a file path for the masked image
    savePath = imagePath.split("/")
    imageFullName = savePath.pop() # Removes the last element of savePath and also saves it as imageFullName. ex: "000636.png"
    imageFullName = imageFullName.split(".")
    imageName = imageFullName[0]
    imageExtension = imageFullName[1]

    maskedImageName = imageName + "_masked." + imageExtension
    savePath.append(maskedImageName)

    savePath = "/".join(savePath)
    # print(savePath)
    plt.savefig(savePath)

    # cv2.imwrite(savePath, maskedImage)

    return mask

"""
    Takes in the image path and the mask and then outputs the histogram information
"""
def getHistogram(imagePath, mask):
    image = cv2.imread(imagePath)

    hist = cv2.calcHist([image], [0, 1, 2], mask, [8, 8, 8], [0, 256, 0, 256, 0, 256])
    hist = cv2.normalize(hist, None)
    hist.flatten()

    # print(hist)
    saveInfo(hist, "histogram.csv", "./TextBoxes/examples")
    return hist 

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
    Outputs a dictionary of histograms
"""
def histDict():
    fileList, picList = getCoordinates() # calls getCoordinates to get the box coordinates in a list (NOT ACTUALLY A PYTHON LIST)
    imgList = getImages()
    index = {}
    images = {}

    for i in range(len(picList)):
        image = imgList[i] # gets path of image
        coordList = picList[i] # the list of box coordinates for that image

        img = cv2.imread(image)
        imageName = fileList[i]
        images[imageName] = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        boxNum = 0
        for box in coordList:
            box = box.split(",") # makes the string into a list
           
            xMin = int(box[1])
            yMin = int(box[2])
            xMax = int(box[3])
            yMax = int(box[4])

            # create a mask
            mask = np.zeros(img.shape[:2], np.uint8)
            mask[yMin:yMax, xMin:xMax] = 255 # creates a mask that leaves only the textbox area

            hist = cv2.calcHist([img], [0, 1, 2], mask, [8, 8, 8], [0, 256, 0, 256, 0, 256])
            hist = cv2.normalize(hist, None).flatten()
            index[(imageName, boxNum)] = hist

            boxNum += 1
    
    print(images, index)

""" 
    Finds the vertical line that divides the textbox which has the lowest correlation in color histograms between the two boxes. (Greatest difference)
"""
def findDivide(imagePath, xMin, yMin, xMax, yMax):


""" 
    Wrapper function
"""
def wrapper1():
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

    
def wrapper2():
    fileList, picList = getCoordinates() # calls getCoordinates to get the box coordinates in a list (NOT ACTUALLY A PYTHON LIST)
    imgList = getImages()
    histDict = {}


    for i in range(len(picList)):
        image = imgList[i] # gets path of image
        coordList = picList[i] # the list of box coordinates for that image

        for i in range(len(coordList)):
            box = coordList[i]
            box = box.split(",") # makes the string into a list
            # print(type(int(box[1])))
            xMin = int(box[1])
            yMin = int(box[2])
            xMax = int(box[3])
            yMax = int(box[4])

            mask = createMask(image, xMin, yMin, xMax, yMax)
            hist = getHistogram(image, mask)

            key = str(i)
            histDict[image + key] = hist

    return histDict
    
def compare():
    histDict = wrapper2()
    method = [("Correlation", cv2.HISTCMP_CORREL),
	            ("Chi-Squared", cv2.HISTCMP_CHISQR),
	            ("Intersection", cv2.HISTCMP_INTERSECT), 
	            ("Hellinger", cv2.HISTCMP_BHATTACHARYYA)]
    results = {}
    reverse = True
    for (key, value) in list(histDict.items()):
        d = cv2.compareHist(histDict["./TextBoxes/examples/img/frame423.jpg0"], value, method[0][1])
        results[key] = d
    
    results = sorted([(v, k) for (k, v) in results.items()], reverse = reverse)

    saveInfo(results, "distances.csv", "./TextBoxes/examples")


if __name__=='__main__':
    wrapper1()
    # histDict()
    # imagePath = "./TextBoxes/examples/img/000636.png"

    # imagePath = "./astronaut.png"

    # xMin = 30
    # xMax = 471
    # yMin = 57
    # yMax = 248
    # mask = createMask(imagePath, xMin, yMin, xMax, yMax)
    # getHistogram(imagePath, mask)

    # image = cv2.imread(imagePath)

    # hist = cv2.calcHist([image], [0, 1, 2], None, [8, 8, 8], [0, 256, 0, 256, 0, 256])
    # hist = cv2.normalize(hist, None)
    # hist.flatten()

    # compare()