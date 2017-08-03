import cv2
import os

DIRECTORY = 

newdir = DIRECTORY + "/" + "subtraction"

for filename in os.listdir(DIRECTORY):
	
IMAGE_1 = "1020.jpg"
IMAGE_2 = "1017.jpg"

#Apply median blur to image
img1 = cv2.imread(IMAGE_1)
img2 = cv2.imread(IMAGE_2)
img1 = cv2.medianBlur(img1,5)
img2 = cv2.medianBlur(img2,5)

#Subtraction and display of subtracted image
#Better than im1-im2 as it prevents values from going below 0
img3 = cv2.subtract(img2, img1)


cv2.imshow("pre-Threshold", img3)
cv2.waitKey(0)

#Convert to gray and then displau
img3 = cv2.cvtColor(img3, cv2.COLOR_BGR2GRAY)
cv2.imshow("pre-Threshold Gray", img3)
cv2.waitKey(0)

#Do a laplacian transform for edge detection
#displays and saves
laplacian1 = cv2.Laplacian(img3,cv2.CV_64F)
cv2.imshow("Laplacian1", laplacian1)
cv2.imwrite("Laplacian1.tif", laplacian1)
cv2.waitKey(0)

#Binary threshold, laplace edge detection, display, save
ret, thresh = cv2.threshold(img3, 10, 255, cv2.THRESH_BINARY)
ret, thresh = cv2.threshold(thresh, 1, 255, cv2.THRESH_BINARY)
cv2.imshow("post-Threshold", thresh)
cv2.waitKey(0)

laplacian2 = cv2.Laplacian(thresh,cv2.CV_64F)
cv2.imshow("Laplacian2", laplacian2)
cv2.imwrite("Laplacian2.tif", laplacian2)
cv2.waitKey(0)

#Adaptive threshold: sometimes really good, sometimes terrible, honestly, it's a toss up.
th = cv2.adaptiveThreshold(img3, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 115, 1)
cv2.imshow("Adapative threshold", th)
cv2.imwrite("Adaptive.tif", th)
cv2.waitKey(0)

#Laplacian 3, edge detection on the adaptive threshold
laplacian3 = cv2.Laplacian(th,cv2.CV_64F)
cv2.imshow("Laplacian3", laplacian3)
cv2.imwrite("Laplacian3.tif", laplacian3)
cv2.waitKey(0)
