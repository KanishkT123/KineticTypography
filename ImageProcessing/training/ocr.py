from PIL import Image
import pytesseract
import cv2
import os

IMPATH = "./Macklemore/frame_169_Macklemore.jpg"
BOXPATH = "./MackBox/frame_169_Macklemore.txt"
BLUR = True


img = cv2.imread(IMPATH)
cv2.imshow("original", img)
cv2.waitKey(0)
croppedList = []
with open(BOXPATH, 'r') as file:
	for line in file:
		coords = line.split(',')
		xmin = int(coords[1])
		ymin = int(coords[2])
		xmax = int(coords[3])
		ymax = int(coords[4])
		currentCrop = img[ymin:ymax, xmin:xmax]
		currentCrop = cv2.cvtColor(currentCrop, cv2.COLOR_BGR2GRAY)
		croppedList.append(currentCrop)
if BLUR:
	for croppedIm in croppedList:
		croppedIm = cv2.medianBlur(croppedIm, 3)

count = 0
for croppedIm in croppedList:
	filename = str(count) + "{}.png".format(os.getpid())
	cv2.imwrite(filename, croppedIm)
	cv2.imshow("cropped", croppedIm)
	cv2.waitKey(0)
	text = pytesseract.image_to_string(Image.open(filename))
	count += 1
	print(text)
