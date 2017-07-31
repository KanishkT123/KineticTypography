import os
import cv2
import numpy as np
import csv
from matplotlib import pyplot as plt
from sklearn.cluster import KMeans

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
    Takes in information and a file path and writes and saves that information as a csv file
"""
def saveInfo(information, fileName, filePath):
    # Writes the path to save the file
    savePath = os.path.join(filePath, fileName)

    with open(savePath, "w", newline="") as file:
        writer = csv.writer(file)
        writer.writerows(information)



"""
    Goes through the results directory and returns a list of lists
    of textbox coordinates, with each separate image as an inner list, as well as a list of image filenames
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

    NOTE: all the stuff that's been commented out was because another function calls this 
          multiple times and the computer can't handle making plots and saving each of the masks
          Now it only returns the mask without saving or showing any plots.
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
    Takes in the image path and the mask and then returns the histogram information and saves it as a csv
"""
def getHistogram(imagePath, mask):
    image = cv2.imread(imagePath)

    hist = cv2.calcHist([image], [0, 1, 2], mask, [8, 8, 8], [0, 256, 0, 256, 0, 256])
    hist = cv2.normalize(hist, None)
    hist.flatten()

    saveInfo(hist, "histogram.csv", "./TextBoxes/examples")
    return hist 



"""
    Calculates a histogram for the red and green channel given an image path and a mask
"""
def twoHistogram(imagePath, mask):
    img = cv2.imread(imagePath)

    color = ('b','g','r')
    hist = cv2.calcHist([img],[1],mask,[256],[0,256]) # green histogram
    hist = cv2.normalize(hist, None)
    plt.plot(hist,color = 'g')

    hist = cv2.calcHist([img],[2],mask,[256],[0,256]) # red histogram
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

    for rightLine in range(xMin + splitWidth, xMax, splitWidth):
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




"""
    Cutting off a width of 10 pixels from either side of the image, findCorrelations plots the correlation
    between the left and right color histograms for every vertical splitting line in the image
"""
def findCorrelations(imagePath, xMin, yMin, xMax, yMax):
    outputList = []
    for line in range(xMin + 10, xMax - 10): 
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
    Takes in the image (not image path), and the coordinates of the text box, then returns an 
    average color amount (per pixel) for the entirety of this text box
"""
def sumValue(image, xMin, yMin, xMax, yMax):
    # height and width of the image
    height = yMax - yMin
    width = xMax - xMin
    totalPix = height * width # total number of pixels

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




"""
    Takes in the image path and textbox coordinates, then splits it up into 20 segments
    and gets the average color amounts for each segment, then plots all of these values
"""
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
    Takes in an image and textbox coordinates and returns coordinates signifying (R, G, B) values for all pixels in the text box
"""
def colorCoords(image, xMin, yMin, xMax, yMax):
    height = yMax - yMin
    width = xMax - xMin
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

    coords = [red, green, blue]
    return coords




""" 
    Takes in image path, and coordinates of the textbox, then gets the average color values for each segment and returns
    all of the color coordinates as a list
"""
def segmentedCoords(imagePath, xMin, yMin, xMax, yMax):
    image = cv2.imread(imagePath)
    numSplit = 20

    width = xMax - xMin
    splitWidth = width // numSplit
    leftLine = xMin # Initial value of left

    coordList = []

    for rightLine in range(xMin + splitWidth, xMax, splitWidth):
        coords = colorCoords(image, leftLine, yMin, rightLine, yMax)

        coordList.append(coords)

        leftLine = rightLine # Reset value of leftLine

    return coordList




"""
    Takes in an image and returns all color coordinates for each pixel in the image as a list
"""
def allCoords(image):
    height, width, channels = image.shape 

    coordList = []

    for row in range(height):
        for col in range(width):
            pixel = image[row][col]

            blueVal = pixel[0]
            greenVal = pixel[1]
            redVal = pixel[2]
            
            coords = [redVal, greenVal, blueVal]
            coordList.append(coords)

    return coordList



""" 
    Wrapper function: shows the masked histogram for every textbox for every image in the img directory
"""
def showHist():
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



"""
    Goes through all the images in the img directory then makes a histogram for each textbox in the image and adds it to a dictionary.
    Returns a dictionary where the key is the image name and the textbox number and the value is the color histogram
"""
def getHistDict():
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




"""
    Takes in a dictionary of histograms and the key of the histogram to compare all others to, then uses correlation
    to compare the histograms and returns the results sorted in reverse
"""
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




"""
    Takes in the image path, textbox coordinates, and the number of clusters and does k-means clustering
    on the color values of segments in the textbox.
    Returns the inertia
"""
def wrapperForCluster(imagePath, xMin, yMin, xMax, yMax, numClusters):
    coordList = segmentedCoords(imagePath, xMin, yMin, xMax, yMax)

    xArray = np.array(coordList)

    kmeans = KMeans(n_clusters = numClusters).fit(xArray)

    # print(kmeans.cluster_centers_)
    # print(kmeans.labels_)
    # print(kmeans.inertia_)

    return kmeans.inertia_



"""
    Takes in the image path, the text box coordinates and the number of clusters then
    does k-means clustering on the textbox's segmented color values. It then uses this model to 
    predict the clusters for every pixel in the image.

    Returns a list of predictions
"""
def findLines(imagePath, xMin, yMin, xMax, yMax, numClusters):
    coordList1 = segmentedCoords(imagePath, xMin, yMin, xMax, yMax) # get average colors for every segment

    xArray = np.array(coordList1) # make it into numpy array

    kmeans = KMeans(n_clusters = numClusters).fit(xArray)
    image = cv2.imread(imagePath)

    coordList2 = allCoords(image) # get color coordinates for all pixels
    pixArray = np.array(coordList2) # make it into numpy array

    # print(kmeans.cluster_centers_)
    # print(kmeans.labels_)
    # print(kmeans.inertia_)

    return kmeans.predict(pixArray)


"""
    Takes in an array of predictions for every pixel in an image, and the image path. Then it checks if the
    prediction was yellow, and if it was, it adds it to a list of x and y coordinates of the pixel and returns this list
"""
def getColor(pixArray, imagePath):
    image = cv2.imread(imagePath)
    height, width, channels = image.shape 

    xList = []
    yList = []

    # locationList = []

    # 0 = blue, 1 = white, 2 = yellow
    for i in range(len(pixArray)):
        if pixArray[i] == 2:
            row = i // height # PixArray is completely flat like: [1, 1, 0, 0, 0, 1, 2] so I thought this would give me the right x and y values
            col = i % height

            xList.append(row)
            yList.append(col)
            # pixCoords = [row, col]
            # locationList.append(pixCoords)

    # print(locationList)
    return xList, yList




"""
    For the numClusters, it calculates the inertia for each number of clusters from 1 to numClusters + 1 and returns the inertia as a list
"""
def inertiaTester(imagePath, xMin, yMin, xMax, yMax, numClusters):
    inertiaList = []
    for num in range(1, numClusters + 1):
        inertia = wrapperForCluster(imagePath, xMin, yMin, xMax, yMax, num)
        inertiaList.append(inertia)

    return inertiaList




"""
    Takes in the list of inertia values and then plots the percent change
"""
def plotPercents(inertiaList):
    percentList = []
    for i in range(len(inertiaList) - 1):
        percentChange = (inertiaList[i] - inertiaList[i + 1])/inertiaList[i]
        percentList.append(percentChange)
    
    print(percentList)
    xList = range(1, len(percentList) + 1)
    plt.plot(xList, percentList)
    plt.show()




if __name__=='__main__':
    imagePath = './TextBoxes/examples/img/cool.png'
    xMin = 29
    yMin = 25
    xMax = 716
    yMax = 101

    # xMin = 184  THESE ARE THE ACTUAL COORDINATES FOR THE YELLOW "I" IN COOL.PNG
    # yMin = 27
    # xMax = 196
    # yMax = 93


    # imagePath = './TextBoxes/examples/img/pink.png'
    # xMin = 220
    # yMin = 156
    # xMax = 531
    # yMax = 201

    pixArray = findLines(imagePath, xMin, yMin, xMax, yMax, 3)
    xList, yList = getColor(pixArray, imagePath)

    plt.scatter(xList, yList)
    plt.show()