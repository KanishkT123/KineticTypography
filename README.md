# KineticTypography
Kinetic Typography Project at HMC

HTML/CSS/JavaScript Work: 

https://codepen.io/celinepark/pen/zzYrNj (Alliteration bouncing example)
https://codepen.io/celinepark/pen/mwbwWQ (Rotating text)
https://codepen.io/celinepark/pen/YQKaYO (Canvas bouncing text)
https://codepen.io/celinepark/pen/PjWwoY (Kinetic typography bouncing logo)
https://codepen.io/celinepark/pen/wedPwP (Sliding text)


## For Letter Box Detection (Old version):

All of the code is in histogram.py
Save the image you want to run the letter box detection in the same folder/sub-folder as histogram.py

It should already be under __main__, but update the variable imagePath to be your image, then call getBounding(imagePath, numClusters)
numClusters should be the number of colors in the image, including the background color.


## For Frame Subtraction/Letter Box Detection (Newest version):

Cleaned up code is in letterBox.py
First, you need to download the YouTube video using:
`youtube-dl -f 22 video_url`
As far as I know, youtube-dl doesn't seem to work on Shadowfax, so this needs to be run on a local machine. 

Then the video should be split into frames using ffmpeg:
`ffmpeg -i video.webm ./FrameDirectory/thumb%04d.jpg -hide_banner`

I'd recommend saving all of the frames to one directory. The loop that goes through the directory increments the frame number rather than walking through the directory using the Python `os` library, so you will need to input the total number of frames. (This is one potential spot for improvement of code!)

Then, you can use `processFrames()` which will basically handle everything and go thorugh the specified frame directory, run inter-frame subtraction on sequential frames, and write results to another specified directory. 
