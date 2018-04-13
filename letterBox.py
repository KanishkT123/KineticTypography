import os
import sys
import cv2
import numpy as np
import pytesseract
from PIL import Image
from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
from scipy.spatial import distance
from scipy import stats
from operator import itemgetter
import nltk_metrics_distance


"""
    Helper function for sorting rectangles
"""
def getKey(rect):
    center = rect[0]
    return center[0]

"""
    Get bounding boxes around each letter 
"""
def getBounding(imagePath, numClusters, resultName):
    ogImage = cv2.imread(imagePath) # Save original image
    image = cv2.imread(imagePath)
    # img_copy = cv2.imread(imagePath)

    # thresh = cv2.imread("post-Threshold.tif", 0) # Read in mask image

    # image = cv2.bitwise_and(image, image, mask = thresh) # Apply mask to image
   
    # print("About to write maskedIm.png")
    # cv2.imwrite("maskedIm.png", image)

    height, width, channels = image.shape

    print("Calling getPredictions")
    labels, clusterCenters = getPredictions(image, numClusters)

    print("Going into for loop for number of clusters")
    for cluster in range(numClusters):
        mask = np.zeros(image.shape[:2], np.uint8)

        print("Calling getColor")
        xList, yList = getColor(labels, imagePath, cluster)
        print("Finished getColor")
        for i in range(len(xList)):
            xVal = xList[i]
            yVal = yList[i]

            mask[yVal, xVal] = 255
    
        kernel = np.ones((5,5),np.uint8)
        # mask = cv2.dilate(mask, kernel, iterations = 2)
        # mask = cv2.erode(mask, kernel, iterations = 2)
        mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
        cv2.imwrite("mask.png", mask)
        
        masked = cv2.imread("mask.png")
        print("Calling findContours")
        _ , contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        cropName = 0
        for cnt in contours:
            rectList = []

            cropName += 1
            rect = cv2.minAreaRect(cnt)
            print("Adding to actualRect")

            h, w = rect[1] # get width and height of rectangle
            box = cv2.boxPoints(rect) # get vertices
            box = np.int0(box) # round to nearest integer

            # print("about to call crop2")
            croppedRotated = crop2(rect, box, masked, str(cropName))
            findColor(croppedRotated)
            # print("finished crop2")

            rect = box.tolist() # save vertices as a python list

            if w not in range(width - 25, width + 10) and h not in range(height - 25, height + 10):
                rectList.append(rect)
                # ogImage = cv2.drawContours(ogImage, [box], -1, (255,0,0), 2)
                ogImage = cv2.drawContours(masked, [box], -1, (255,0,0), 2)

                print("Writing image with box drawn")
                cv2.imwrite(resultName, ogImage) # Save image




"""
    Takes in the frame subtracted image, then gets bounding boxes around each letter 
"""
def getBoundingBinary(thresh, resultName):
    # Only 2 colors -- black and white
    numClusters = 2

    height, width = thresh.shape

    kernel = np.ones((5,5), np.uint8)
    # mask = cv2.dilate(mask, kernel, iterations = 2)
    # mask = cv2.erode(mask, kernel, iterations = 2)
    mask = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel)
    cv2.imwrite("mask.png", mask)
    
    masked = cv2.imread("mask.png")
    _ , contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    cropName = 0
    actualRect = []
    for cnt in contours:
        rectList = []

        cropName += 1
        rect = cv2.minAreaRect(cnt)
        actualRect.append(rect)

        h, w = rect[1] # get width and height of rectangle
        box = cv2.boxPoints(rect) # get vertices
        box = np.int0(box) # round to nearest integer

        # print("about to call crop2")
        # # crop2(rect, box, masked, str(cropName))
        # print("finished crop2")

        rect = box.tolist() # save vertices as a python list

        if w not in range(width - 25, width + 10) and h not in range(height - 25, height + 10):
            rectList.append(rect)
            # ogImage = cv2.drawContours(ogImage, [box], -1, (255,0,0), 2)
            ogImage = cv2.drawContours(masked, [box], -1, (255,0,0), 2)

            cv2.imwrite(resultName, ogImage) # Save image

    actualRect = sorted(actualRect, key=getKey)
    if len(actualRect) == 0:
        print("uhh no... " + resultName)
        return
    else:
        rect1 = actualRect[0]
        box1 = cv2.boxPoints(rect1)
        box1 = np.int0(box1)
        cropR1 = crop2(rect1, box1, masked, str(cropName))
        cv2.imwrite("cropR1.png", cropR1)

        if len(actualRect) > 1:
            rect2 = actualRect[1]
            box2 = cv2.boxPoints(rect2)
            box2 = np.int0(box2)
            cropR2 = crop2(rect2, box2, masked, str(cropName))
            cv2.imwrite("cropR2.png", cropR2)

            out = boxAppend("cropR1.png", "cropR2.png")
            cv2.imwrite("out.png", out)
            template = cropR1

            for i in range(len(actualRect)):
                print("i is equal to" + str(i))
                rect = actualRect[i] 
                box = cv2.boxPoints(rect) # get vertices
                box = np.int0(box) # round to nearest integer

                crop = crop2(rect, box, masked, str(cropName)) # create cropped letter image
                # cropResized = makeSameSize(template, crop, resultName)
                cv2.imwrite("crop.png", crop)

                if i != 0 and i != 1:
                    out = boxAppend("out.png", "crop.png")
                    cv2.imwrite("out.png", out)
            pad(out, "padout.png")
            outP = cv2.imread("padout.png")
            txt = ocr(outP)
            print("About to add ocr output")

            with open("OCR_output_all.txt", "a") as text_file:
                text = txt + "\n"
                text_file.write(text)
            outName = "appended_" + resultName
            cv2.imwrite(outName, out)



"""
    Get bounding boxes around each letter 
"""
def getBoundingwithFrameSub(imagePath, numClusters, resultName):
    ogImage = cv2.imread(imagePath) # Save original image
    image = cv2.imread(imagePath)
    # img_copy = cv2.imread(imagePath)

    thresh = cv2.imread("post-Threshold.tif", 0) # Read in mask image

    # image = cv2.bitwise_and(image, image, mask = thresh) # Apply mask to image
   
    print("About to write maskedIm.png")
    cv2.imwrite("maskedIm.png", image)

    height, width, channels = image.shape

    print("Calling getPredictions")
    labels, clusterCenters = getPredictions(image, numClusters)

    print("Going into for loop for number of clusters")
    for cluster in range(numClusters):
        mask = np.zeros(image.shape[:2], np.uint8)

        print("Calling getColor")
        xList, yList = getColor(labels, imagePath, cluster)
        print("Finished getColor")
        for i in range(len(xList)):
            xVal = xList[i]
            yVal = yList[i]

            mask[yVal, xVal] = 255
    
        kernel = np.ones((5,5),np.uint8)
        # mask = cv2.dilate(mask, kernel, iterations = 2)
        # mask = cv2.erode(mask, kernel, iterations = 2)
        mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
        cv2.imwrite("mask.png", mask)
        
        masked = cv2.imread("mask.png")
        print("Calling findContours")
        _ , contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        cropName = 0
        actualRect = []
        for cnt in contours:
            rectList = []

            cropName += 1
            rect = cv2.minAreaRect(cnt)
            print("Adding to actualRect")
            actualRect.append(rect)

            h, w = rect[1] # get width and height of rectangle
            box = cv2.boxPoints(rect) # get vertices
            box = np.int0(box) # round to nearest integer

            # print("about to call crop2")
            # # crop2(rect, box, masked, str(cropName))
            # print("finished crop2")

            rect = box.tolist() # save vertices as a python list

            if w not in range(width - 25, width + 10) and h not in range(height - 25, height + 10):
                rectList.append(rect)
                # ogImage = cv2.drawContours(ogImage, [box], -1, (255,0,0), 2)
                ogImage = cv2.drawContours(masked, [box], -1, (255,0,0), 2)

                print("Writing image with box drawn")
                cv2.imwrite(resultName, ogImage) # Save image

        actualRect = sorted(actualRect, key=getKey)
        rect1 = actualRect[0]
        print(actualRect)
        box1 = cv2.boxPoints(rect1)
        box1 = np.int0(box1)
        cropR1 = crop2(rect1, box1, masked, str(cropName))
        cv2.imwrite("cropR1.png", cropR1)

        if len(actualRect) > 1:
            rect2 = actualRect[1]
            box2 = cv2.boxPoints(rect2)
            box2 = np.int0(box2)
            cropR2 = crop2(rect2, box2, masked, str(cropName))
            cv2.imwrite("cropR2.png", cropR2)

            out = boxAppend("cropR1.png", "cropR2.png")
            cv2.imwrite("out.png", out)
            template = cropR1

            for i in range(len(actualRect)):
                print("i is equal to" + str(i))
                rect = actualRect[i] 
                box = cv2.boxPoints(rect) # get vertices
                box = np.int0(box) # round to nearest integer

                crop = crop2(rect, box, masked, str(cropName)) # create cropped letter image
                # cropResized = makeSameSize(template, crop, resultName)
                cv2.imwrite("crop.png", crop)

                if i != 0 and i != 1:
                    print("About to append")
                    out = boxAppend("out.png", "crop.png")
                    cv2.imwrite("out.png", out)
            pad(out, "padout.png")
            outP = cv2.imread("padout.png")
            ocr(outP)
            outName = "appended_" + resultName
            cv2.imwrite(outName, out)



"""
    Does the same thing as findLines but using all coordinates
"""
def getPredictions(image, numClusters):
    print("Calling allCoords")
    coordList = allCoords(image)
    print("Finished allCoords")
    
    xArray = np.array(coordList) # make it into numpy array

    kmeans = KMeans(n_clusters = numClusters).fit(xArray)

    # print(kmeans.cluster_centers_)
    # print(kmeans.labels_)
    # print(kmeans.inertia_)

    return kmeans.labels_, kmeans.cluster_centers_


"""
    Takes in an image and returns all color coordinates for each pixel in the image as a list
"""
def allCoords(image):
    height, width, channels = image.shape 
    # height, width = image.shape 

    coordList = []

    for row in range(height):
        for col in range(width):
            pixel = image[row][col]

            blueVal = pixel[0]
            greenVal = pixel[1]
            redVal = pixel[2]
            
            coords = [redVal, greenVal, blueVal]
            coordList.append(coords)

    # for row in range(height):
    #     for col in range(width):
    #         pixel = image[row][col]

    #         # coords = [redVal, greenVal, blueVal]
    #         coordList.append(pixel)

    return coordList


"""
    Takes in an array of predictions for every pixel in an image, and the image path. Then it checks if the
    prediction was the specified color, and if it was, it adds it to a list of x and y coordinates of the pixel and returns this list
"""
def getColor(pixArray, imagePath, clusterNumber):
    image = cv2.imread(imagePath)
    height, width, channels = image.shape 

    xList = []
    yList = []

    # locationList = []

    # 0 = blue, 1 = white, 2 = yellow

    for row in range(height):
        for col in range(width): 
            idx = row * width + col
            if pixArray[idx] == clusterNumber: 
                xList.append(col)
                yList.append(row)

    for i in range(len(pixArray)):
        if pixArray[i] == clusterNumber:
            # JM: Changed height to width here, since the arrays are one row at a time. 
            row = i // width 
            col = i % width

            xList.append(col)
            yList.append(row)

    # print(locationList)
    return xList, yList


"""
    Takes in a binary mask, returns the x and y coordinates of the white pixels in the image
"""
def getColorThresh(thresh):
    height, width = thresh.shape 

    xList = []
    yList = []

    for row in range(height):
        for col in range(width): 
            idx = row * width + col
            if thresh[idx] == 255: 
                xList.append(col)
                yList.append(row)

    # for i in range(len(pixArray)):
    #     if pixArray[i] == clusterNumber:
    #         row = i // width 
    #         col = i % width

    #         xList.append(col)
    #         yList.append(row)

    # print(locationList)

    return xList, yList


"""
    Subtracts image2 from image1 
    If selecting frames individually, image2 is background
"""
def frameSubtract(imageName1, imageName2):
    image1 = cv2.imread(imageName1)
    image2 = cv2.imread(imageName2)
    image1 = cv2.medianBlur(image1,5)
    image2 = cv2.medianBlur(image2,5)

    #Subtraction and display of subtracted image
    #Better than im1-im2 as it prevents values from going below 0
    image3 = cv2.subtract(image2, image1)

    # cv2.imwrite("framesub.png", image3)


    #Convert to gray and then display
    image3 = cv2.cvtColor(image3, cv2.COLOR_BGR2GRAY)

    # cv2.imwrite("pre-Threshold Gray", image3)
    # cv2.waitKey(0)
    print("About to write framesub.png")

    cv2.imwrite("framesub.png", image3)

    #Do a laplacian transform for edge detection
    #displays and saves
    laplacian1 = cv2.Laplacian(image3,cv2.CV_64F)
    # cv2.imshow("Laplacian1", laplacian1)

    print("About to write Laplacian1.tif")
    cv2.imwrite("Laplacian1.tif", laplacian1)
    # cv2.waitKey(0)

    #############################
    #############################
    #### Mask
    #############################

    #Binary threshold, laplace edge detection, display, save
    ret, thresh = cv2.threshold(image3, 10, 255, cv2.THRESH_BINARY)
    ret, thresh = cv2.threshold(thresh, 1, 255, cv2.THRESH_BINARY)

    print("About to write post-Threshold.tif")
    cv2.imwrite("post-Threshold.tif", thresh)
    # cv2.waitKey(0)
    
    # return thresh

    laplacian2 = cv2.Laplacian(thresh,cv2.CV_64F)
    # cv2.imshow("Laplacian2", laplacian2)

    print("About to write Laplacian2.tif")
    cv2.imwrite("Laplacian2.tif", laplacian2)
    # # cv2.waitKey(0)


    #Adaptive threshold: sometimes really good, sometimes terrible, honestly, it's a toss up.
    th = cv2.adaptiveThreshold(image3, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 115, 1)
    # cv2.imshow("Adapative threshold", th)

    print("About to write Adaptive.tif")
    cv2.imwrite("Adaptive.tif", th)
    # cv2.waitKey(0)

    #Laplacian 3, edge detection on the adaptive threshold
    laplacian3 = cv2.Laplacian(th,cv2.CV_64F)
    # cv2.imshow("Laplacian3", laplacian3)

    print("About to write Laplacian3.tif")
    cv2.imwrite("Laplacian3.tif", laplacian3)

    return thresh


"""
    Subtracts image2 from image1 
    If selecting frames individually, image2 is background
"""
def frameSubtractBin(imageName1, imageName2):
    image1 = cv2.imread(imageName1)
    image2 = cv2.imread(imageName2)

    #Subtraction and display of subtracted image
    #Better than im1-im2 as it prevents values from going below 0
    image3 = cv2.subtract(image2, image1)

    #Convert to gray and then display
    image3 = cv2.cvtColor(image3, cv2.COLOR_BGR2GRAY)

    #############################
    #############################
    #### Mask
    #############################


    #Binary threshold, laplace edge detection, display, save
    ret, thresh = cv2.threshold(image3, 15, 255, cv2.THRESH_BINARY)
    ret, thresh = cv2.threshold(thresh, 1, 255, cv2.THRESH_BINARY)


    # Basic threshold
    # Doesn't work...
    # ret, thresh = cv2.threshold(image3, 0, 255, cv2.THRESH_BINARY)

    print("About to write post-Threshold.tif")
    cv2.imwrite("post-Threshold.tif", thresh)

    return thresh



def crop(rect):
    # rect is the RotatedRect (I got it from a contour...)

    # matrices we'll use
    # Mat M, rotated, cropped
    # get angle and size from the bounding box
    angle = rect[-1]
    # rect_size = rect.size
    # thanks to http://felix.abecassis.me/2011/10/opencv-rotation-deskewing/
    if (rect.angle < -45.):
        angle += 90.0
        h, w = rect[1]
        swap(w, h)
    # get the rotation matrix
    M = getRotationMatrix2D(rect.center, angle, 1.0)
    # perform the affine transformation
    warpAffine(src, rotated, M, src.size(), INTER_CUBIC)
    # crop the resulting image
    getRectSubPix(rotated, rect_size, rect.center, cropped)
    
    cv2.imwrite("cropped.tif", cropped)



""" This is the one that works
    It takes in a single rectangle rect, its coordinates box, the original image img
    and resultName. It then does stuff and crops the rotated rectangle, adds a border
    then calls tesseract on the padded image

    ...only if pytesseract would actually work...
"""
def crop2(rect, box, img, resultName):
    # I got this code from: https://stackoverflow.com/questions/37177811/crop-rectangle-returned-by-minarearect-opencv-python
    W = rect[1][0]
    H = rect[1][1]
    mult = 1.0

    Xs = [i[0] for i in box]
    Ys = [i[1] for i in box]
    x1 = min(Xs)
    x2 = max(Xs)
    y1 = min(Ys)
    y2 = max(Ys)

    rotated = False
    angle = rect[2]

    if angle < -45:
        angle+=90
        rotated = True

    center = (int((x1+x2)/2), int((y1+y2)/2))
    size = (int(mult*(x2-x1)),int(mult*(y2-y1)))

    M = cv2.getRotationMatrix2D((size[0]/2, size[1]/2), angle, 1.0)

    cropped = cv2.getRectSubPix(img, size, center)    
    cropped = cv2.warpAffine(cropped, M, size)

    croppedW = W if not rotated else H 
    croppedH = H if not rotated else W

    # THIS is the cropped and unskewed letter
    croppedRotated = cv2.getRectSubPix(cropped, (int(croppedW*mult), int(croppedH*mult)), (size[0]/2, size[1]/2))
    
    # sets border type to constant
    borderType = cv2.BORDER_CONSTANT
    # borderType = cv2.BORDER_REPLICATE
    #^ doesn't work

    # Basically how big you want the border to be
    perc = 10.0

    top = int(perc * croppedRotated.shape[0])  # shape[0] = rows
    bottom = top
    left = int(perc * croppedRotated.shape[1])  # shape[1] = cols
    right = left
    
    # COLOR of border
    # value = [255, 255, 255]    
    value = [0, 0, 0]    
    dst = cv2.copyMakeBorder(croppedRotated, top, bottom, left, right, borderType, None, value)

    # resultName = "./Results/padded" + resultName
    # resultName += ".png"
    # # Writing padded image
    # cv2.imwrite(resultName, dst)

    # # Calling pytesseract on the image
    # img_n = Image.fromarray(dst)
    # txt = pytesseract.image_to_string(img_n, lang="eng")
    # print(txt)

    # Writing cropped image
    resultName = "./Results/cropped" + resultName
    resultName += ".png"
    # cv2.imwrite(resultName, croppedRotated)
    return croppedRotated

"""
    Uses scipy mode function to return the most common color in one 
    cropped rectangle
"""
def findColor(croppedRotated):
    print("This is the color of this rectangle: ")
    # Since opencv images are technically numpy arrays, use scipy to determine mode
    mode, count = stats.mode(croppedRotated, axis=None)
    print(mode)
    print("\n This is the count of pixels with this color: ")
    print(count)
    print("\n")
    

def pad(croppedRotated, resultName):
    # sets border type to constant
    borderType = cv2.BORDER_CONSTANT
    # borderType = cv2.BORDER_REPLICATE
    #^ doesn't work

    # Basically how big you want the border to be
    perc = 0.7

    top = int(perc * croppedRotated.shape[0])  # shape[0] = rows
    bottom = top
    left = int(perc * croppedRotated.shape[1])  # shape[1] = cols
    right = left
    
    # COLOR of border
    # value = [255, 255, 255]    
    value = [0, 0, 0]  
    dst = cv2.copyMakeBorder(croppedRotated, top, bottom, left, right, borderType, None, value)

    # Writing padded image
    cv2.imwrite(resultName, dst)


""" img is an opencv image
"""
def ocr(img):
    # Calling pytesseract on the image
    img_n = Image.fromarray(img)
    txt = pytesseract.image_to_string(img_n, lang="eng")
    print(txt)
    return txt


"""
    Takes in two file names, gets the images from those file names
    then "appends" them, basically adding the second image right 
    next to the first imagae and outputs an opencv image
"""
def boxAppend(imageFile1, imageFile2):
    img1 = cv2.imread(imageFile1, 0)
    img2 = cv2.imread(imageFile2, 0)

    h1, w1 = img1.shape[:2]
    h2, w2 = img2.shape[:2]

    # Spacing between letters?
    h3 = h2
    w3 = 10
    # space = np.zeros(h3,w3, np.uint8)

    vis = np.zeros((max(h1, h2), w1+w2+w3), np.uint8)
    vis[:h1, :w1] = img1
    # vis[:h3, w1:w1+w3] = space
    vis[:h2, w1+w3:w1+w2+w3] = img2
    # vis = cv2.cvtColor(vis, cv2.COLOR_GRAY2BGR)

    # #create empty matrix
    # vis = np.zeros((max(h1, h2), w1+w2,3), np.uint8)

    # #combine 2 images
    # vis[:h1, :w1,:3] = img1
    # vis[:h2, w1:w1+w2,:3] = img2

    output = cv2.cvtColor(vis, cv2.COLOR_GRAY2BGR)
    # cv2.imwrite("attached.png", output)
    return output


"""
    Given a template (image size you want to copy), an img, which is an opencv
    image, and a result name, it resizes the image to the same height and width
    as the template, then returns the resized image as an opencv image (could be
    rewritten to write out an image as well)
"""
def makeSameSize(template, img, resultName):
    # size = template.shape[:2]
    template = np.zeros(template.shape[:2], np.uint8)

    # template = cv2.resize(img, template, size, 0, 0, cv2.INTER_LINEAR)
    height, width = template.shape[:2]

    dst = cv2.resize(img, (width, height), interpolation = cv2.INTER_LINEAR)
    
    # cv2.imwrite(resultName, dst)
    return dst


"""
    Returns true
    if there has been change between the two frames
"""
def detectChange(thresh):
    # mask = frameSubtract(frame1, frame2)
    
    # Use numpy sum function to simply sum all values in the mask
    energy = np.sum(thresh)

    # Through trial, we have concluded that more than 10 pixels must be white
    # so maybe try like 30
    if energy > 7650:
        return True

    # If almost everything is black, nothing changed between frames
    else:
        return False



"""
    Takes in a list of bounding rectangle centers, (x,y) and sorts
    from left to right
"""
def sortLetters(centerList):
    data.sort(key=itemgetter(1))


"""
    Makes an integer less than 4 digits into a 4-digit string by padding front
    with zeros
"""
def makeFour(num):
    string = str(num)
    pad = 4 - len(string)
    for i in range(pad):
        string = "0" + string
    return string

"""
    Loops through all frames, subtracts it from the one right before it, and if
    there is a change, it calls getBounding on the said frame, then adds all text to 
    a string that gets printed.
"""
def processFrames(numFrames):
    out = ""
    rootDir = "./Frames_3"
    frameName = "/thumb"
    ext = ".png"

    # Loop through each frame
    for i in range(1, numFrames):
        # # If not the last frame
        # if i != numFrames + 1:
        # Get four-digit versions by calling helper function
        str1 = makeFour(i)
        str2 = makeFour(i+1)
        
        # Create the filenames for both frames
        firstFrame = rootDir + frameName + str1 + ext
        secondFrame = rootDir + frameName + str2 + ext

        # Get the frame subtracted image
        thresh = frameSubtractBin(secondFrame, firstFrame)

        # Check if there has been change between frames
        changed = detectChange(thresh)

        if changed == True:
            resultPath = "./Results_2/out" + str(i+1) + ".png"

            getBoundingBinary(thresh, resultPath)


"""
    Uses NLTK in order to output a character error rate between the actual
    video transcript and the OCR version.
"""
def compareText(transcriptName, ocr):
    # Split transcript text file by character
    transcript = open(transcriptName, "r") 
    ocrText = open(ocr, "r")
    letterS = ""
    for line in transcript: 
        for word in line:
            for ch in word:
                if ch.isalpha():
                    letterS += ch.lower()
    print("The length of transcript is")
    print(len(letterS))

    compareS = ""
    for line in ocrText: 
        for word in line:
            for ch in word:
                if ch.isalpha():
                    compareS += ch.lower()
    print("The length of ocr is")
    print(len(compareS))
    # example of letterL = ['t', 'h', 'a', 't', 't', 'h', 'i', 's', 'w']

    dist = nltk_metrics_distance.edit_distance(letterS, compareS, False)
    print(dist)
    return dist


############
""" MAIN """
############

if __name__=='__main__':

    # Error Handling for Command Line Arguments
    if len(sys.argv) != 4:
        print("Usage: cart.py [image name] [number of colors] [result image name]")
        sys.exit("Please make sure to include the image filepath, number of colors, and result image name as command-line arguments")

    # # Save arguments as variables
    imagePath = "./Images/" + sys.argv[1]

    # # imagePath = sys.argv[1]
    colors = int(sys.argv[2])
    resultPath = "./Results/" + sys.argv[3]

    # tr = sys.argv[1]
    # oc = sys.argv[3]
    # num = compareText(tr, oc)
    # print(num)

    # imagePath = './movie635.jpg'
    # colors = 3
    img2 = "./Images/son2.png"
    img1 = "./Images/son3.png"

    # print("About to go into frameSubtract \n")

    # frameSubtract(img1, img2)

    # thresh = frameSubtract(img1, img2)

    # print("About to go into getBounding \n")
    getBounding(imagePath, colors, resultPath)
    
    # numFrames = 1843
    # processFrames(numFrames)

    # python letterBox.py crooked.jpg 2 crookedRes.jpg

    # ffmpeg -i video.webm thumb%04d.jpg -hide_banner
    # ffmpeg -i video.webm -vf fps=1/5 thumb%04d.jpg -hide_banner
    # youtube-dl -o dreamSpeech.mp4 "url"

    # https://www.youtube.com/watch?v=yjENu24QBgs
    # https://www.youtube.com/watch?v=QG4smsvZuiE 