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
    # plt.figure()
    # maskedImage = cv2.bitwise_and(image, image, mask = mask)
    # plt.imshow(cv2.cvtColor(maskedImage, cv2.COLOR_BGR2RGB))
    # plt.figure()


    # # Make a file path for the masked image
    # savePath = imagePath.split("/")
    # imageFullName = savePath.pop() # Removes the last element of savePath and also saves it as imageFullName. ex: "000636.png"
    # imageFullName = imageFullName.split(".")
    # imageName = imageFullName[0]
    # imageExtension = imageFullName[1]

    # maskedImageName = imageName + "_masked." + imageExtension
    # savePath.append(maskedImageName)

    # savePath = "/".join(savePath)
    # # print(savePath)
    # plt.savefig(savePath)

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
    Calculates a histogram for the red and green channel given an image path and a mask
"""
def twoHistogram(imagePath, mask):
    img = cv2.imread(imagePath)

    # create a mask
    # mask = np.zeros(img.shape[:2], np.uint8)
    # mask[yMin:yMax, xMin:xMax] = 255 # creates a mask that leaves only the textbox area
    # masked_img = cv2.bitwise_and(img,img,mask = mask) # original image with the mask over it

    color = ('b','g','r')
    hist = cv2.calcHist([img],[1],mask,[256],[0,256])
    hist = cv2.normalize(hist, None)
    plt.plot(hist,color = 'g')

    hist = cv2.calcHist([img],[2],mask,[256],[0,256])
    hist = cv2.normalize(hist, None)
    plt.plot(hist,color = 'r')
     # plots the histogram
    # plt.xlim([0,256])
    # plt.subplot(122), plt.imshow(cv2.cvtColor(masked_img, cv2.COLOR_BGR2RGB)) 

    # plt.show() 

    print(hist)
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
    Takes in the coordinates of the textbox and the image path and outputs a plot of the histograms for each
    segment of the box
"""
def splitHist(imagePath, xMin, yMin, xMax, yMax):
    numSplit = 20

    width = xMax - xMin
    splitWidth = width // numSplit
    leftLine = xMin # Initial value of left

    for rightLine in range(xMin+splitWidth, xMax, splitWidth):
         mask = createMask(imagePath, leftLine, yMin, rightLine, yMax)
         twoHistogram(imagePath, mask)
         leftLine = rightLine




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
    Returns the vertical line and the correlation between the two parts.
"""
def findDivide(imagePath, xMin, yMin, xMax, yMax):
    bestLine = 0
    bestCorr = 1.0
    
    for line in range(xMin + 1, xMax): # skipping xMin because that would not divide the box at all
        histDict = {}

        leftMask = createMask(imagePath, xMin, yMin, line, yMax)
        rightMask = createMask(imagePath, line, yMin, xMax, yMax)

        leftHist = getHistogram(imagePath, leftMask)
        rightHist = getHistogram(imagePath, rightMask)

        histDict["leftHist"] = leftHist
        histDict["rightHist"] = rightHist

        corrList = compare(histDict, "leftHist")

        correlation = corrList[1][0]

        if correlation <= bestCorr:
            bestCorr = correlation
            bestLine = line
    
    info = [bestLine, bestCorr]

    # saveInfo(info, "correlation.csv", "./TextBoxes/examples")

    print(info)

def findCorrelations(imagePath, xMin, yMin, xMax, yMax):
    outputList = []
    for line in range(xMin + 10, xMax - 10): # skipping xMin because that would not divide the box at all
        histDict = {}

        leftMask = createMask(imagePath, xMin, yMin, line, yMax)
        rightMask = createMask(imagePath, line, yMin, xMax, yMax)

        leftHist = getHistogram(imagePath, leftMask)
        rightHist = getHistogram(imagePath, rightMask)

        histDict["leftHist"] = leftHist
        histDict["rightHist"] = rightHist

        corrList = compare(histDict, "leftHist")

        correlation = corrList[1][0]

        outputList.append((line, correlation))


    saveInfo(outputList, "correlation.csv", "./TextBoxes/examples")

    # print(info)

"""
    ahhhhh
"""
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

    for rightLine in range(xMin, xMax + splitWidth, splitWidth):
        blue, green, red = sumValue(image, leftLine, yMin, rightLine, yMax)

        blueList.append(blue)
        greenList.append(green)
        redList.append(red)
        
        leftLine = rightLine
    x = range(len(blueList))

    # plt.subplot(131), plt.plot(x, blueList, color = "b")
    # plt.subplot(132), plt.plot(x, greenList, color = "g")
    # plt.subplot(133), plt.plot(x, redList, color = "r")

    plt.plot(x, blueList, color = "b")
    plt.plot(x, greenList, color = "g")
    plt.plot(x, redList, color = "r")
    plt.show()

    # print(blueList)


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
    
def compare(histDict, compareKey):
    # histDict = wrapper2()
    method = [("Correlation", cv2.HISTCMP_CORREL),
	            ("Chi-Squared", cv2.HISTCMP_CHISQR),
	            ("Intersection", cv2.HISTCMP_INTERSECT), 
	            ("Hellinger", cv2.HISTCMP_BHATTACHARYYA)]
    results = {}
    reverse = True
    for (key, value) in list(histDict.items()):
        d = cv2.compareHist(histDict[compareKey], value, method[0][1])
        results[key] = d
    
    results = sorted([(v, k) for (k, v) in results.items()], reverse = reverse)

    # saveInfo(results, "distances.csv", "./TextBoxes/examples")

    return results


if __name__=='__main__':
    # wrapper1()
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

    # histDict = wrapper2()
    # results = compare(histDict, "./TextBoxes/examples/img/frame423.jpg0")
    # print(type(results))
    # print(results)

    # results are a list
    # [(1.0, './TextBoxes/examples/img/frame423.jpg0'), (0.9857310647183112, './TextBoxes/examples/img/frame423.jpg1')]

    imagePath = './TextBoxes/examples/img/cool.png'
    xMin = 29
    yMin = 56
    xMax = 693
    yMax = 101
    # # line = 619

    # # info = findDivide(imagePath, xMin, yMin, xMax, yMax)

    # # findCorrelations(imagePath, xMin, yMin, xMax, yMax)
    # maskedHist(imagePath, xMin, yMin, xMax, yMax)

    # splitHist(imagePath, xMin, yMin, xMax, yMax)
    segment(imagePath, xMin, yMin, xMax, yMax)