img = cv2.imread("frame423.jpg")
color = ('b','g','r')

mask = np.zeros(img.shape[:2], np.uint8)
mask[ymin:(ymax-ymin+1), xmin:(xmax-xmin+1)] = 255
masked_img = cv2.bitwise_and(img,img,mask = mask)
chans = cv2split(masked_img)

hist_mask = cv2.calcHist([img],[0],mask,[256],[0,256])
