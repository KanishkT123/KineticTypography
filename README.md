# KineticTypography
Kinetic Typography Project at HMC

The Reading Kitty App is stored on this repository.

# How to Clone to Xcode
Xcode has its own special procedures when using GitHub -- there is no need to use the terminal. The following link has instructions on how to use GitHub in Xcode:
https://www.raywenderlich.com/153084/use-git-source-control-xcode-9

# How to Create a Default Story
To create a default story, it's XML file and title must be stored. The step to do so are shown below:
1. Create the XML file on the local computer. The name of the file must match the story's title.
2. On the left panel in Xcode, click on the Reading Kitty project with the blue icon. Then go to Build Phases, then Copy Bundle Resources,and click on the plus sign.
3. Click "add other" and then add the XML file.
4. On the left panel in Xcode, click on ModelController.swift. In the Data struct, there is an array called defaultBooks, which stores Book structs.
5. In defaultBooks, create a new Book struct, which has three parameters: file, level, and sections. For file, put the story's title. For level, put the corresponding level, ranging from 0 to 7, not 1 to 8. For sections, put an empty array.
6. If the app has already been launched before, delete the app on the device before running it.

# How to Implement a Kinetic Typography Video
Once the files and methods to make a kinetic typography video have been created, follow the steps below. Note that the video must be in MP4 format. If there are no local files on the computer that need to be imported to Xcode, skip steps 1-3.
1. On the left panel in Xcode, click on the Reading Kitty project with the blue icon. Then, go to Build Phases, then Copy Bundle Resources.
2. Click on "Emperor's New Clothes.mp4", and then click the minus sign.
3. Click on the plus sign, click "add other," and then add a file necessary to create a video. Repeat this step until all necessary files have been added.
4. On the left panel in Xcode, click on Student>Book>VideoPlayerViewController.swift.
5. In the playButton() function's if statement (line 135), change the condition to be what is commented in the line above.
6. In the makeVideo() function under the "Create video" comment (line 114), add the necessary code to create the video.
7. Save the video file's name as a string to videoFileName.
8. Save the video file to the documents directory. Research on how to do this needs to be done, depending on how to access the video's file.

# How to Implement Feedback
Once the files and methods to make a kinetic typography video have been cre- ated, follow the steps below. If there are no local files on the computer that need to be imported to Xcode, skip steps 1 through 2.
1. On the left panel in Xcode, click on the Reading Kitty project with the blue icon. Then, go to Build Phases, then Copy Bundle Resources.
2. Click on the plus sign, click “add other,” and then add a file necessary to create a video. Repeat this step until all neccessary files have been added.
3. On the left panel in Xcode, click on Strudent>Book>VideoPlayerViewController.swift.
4. In the makeVideo() function under the “Generate feedback” comment (line 104), add the neccessary code to generate feedback.
5. Save the feedback as a string to the feedback variable.

# How to Delete the Timer
Once the makeVideo() function has been completed to include both making the video and generating feedback, follow the steps below to delete the timer.
1. On the left panel in Xcode, click on Strudent>Book>VideoPlayerViewController.swift.
2. Delete the timer and invalidated variables (lines 30-31).
3. In the viewDidAppear() function, delete everything between the “Start deleting here” and “Stop deleting here” comments (lines 66-77), and un- comment the call to the makeVideo() function (line 79).
4. Delete the timerOff() function (line 83).
