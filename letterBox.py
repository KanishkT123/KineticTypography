import os
import sys
import cv2
import numpy as np
from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
from scipy.spatial import distance




"""
    Get bounding boxes around each letter 
"""
def getBounding(imagePath, numClusters, resultName):
    ogImage = cv2.imread(imagePath) # Save original image
    image = cv2.imread(imagePath)
    img_copy = cv2.imread(imagePath)

    thresh = cv2.imread("post-Threshold.tif", 0) # Read in mask image

    image = cv2.bitwise_and(image, image, mask = thresh) # Apply mask to image
   
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

        print("Calling findContours")
        _ , contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        for cnt in contours:
            rectList = []

            rect = cv2.minAreaRect(cnt)

            h, w = rect[1] # get width and height of rectangle
            box = cv2.boxPoints(rect) # get vertices
            box = np.int0(box) # round to nearest integer

            print("about to call crop2")
            crop2(rect, box, img_copy)
            print("finished crop2")

            rect = box.tolist() # save vertices as a python list

            if w not in range(width - 25, width + 10) and h not in range(height - 25, height + 10):
                rectList.append(rect)
                ogImage = cv2.drawContours(ogImage, [box], -1, (255,0,0), 2)

                print("Writing image with box drawn")
                cv2.imwrite(resultName, ogImage) # Save image



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


    #Convert to gray and then displau
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


def crop2(rect, box, img):
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

    croppedRotated = cv2.getRectSubPix(cropped, (int(croppedW*mult), int(croppedH*mult)), (size[0]/2, size[1]/2))
    cv2.imwrite("cropped.png", croppedRotated)



############
""" MAIN """
############

if __name__=='__main__':

    # Error Handling for Command Line Arguments
    if len(sys.argv) != 4:
        print("Usage: cart.py [image name] [number of colors] [result image name]")
        sys.exit("Please make sure to include the image filepath, number of colors, and result image name as command-line arguments")

    # Save arguments as variables
    imagePath = "./Images/" + sys.argv[1]
    colors = int(sys.argv[2])
    resultPath = "./Results/" + sys.argv[3]

    # imagePath = './movie635.jpg'
    # colors = 3
    img2 = "./Images/son1.png"
    img1 = "./Images/son2.png"

    print("About to go into frameSubstract \n")

    frameSubtract(img1, img2)
    # thresh = frameSubtract(img1, img2)
    
    # image = cv2.imread(img1)
    # image = cv2.bitwise_and(image, image, mask = thresh)
    # cv2.imwrite("sub.tif", thresh)
    # cv2.imwrite("masked.png", image)

    print("About to go into getBounding \n")
    getBounding(imagePath, colors, resultPath)
