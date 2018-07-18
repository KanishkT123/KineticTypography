//
//  VideoPlayerViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/29/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerViewController: UIViewController {
    /********** LOCAL VARIABLES **********/
    // Audio, text, and video
    var audioURL: URL = URL(fileURLWithPath: "")
    var allText:NSMutableAttributedString = NSMutableAttributedString(string: "")
    var videoFileName: String = ""
    var feedback = ""
    
    // Loading icon
    var makeNewVideo: Bool = false
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    // Buttons
    @IBOutlet weak var buttons: UIStackView!
    
    // Temporary timer
    var timer: Timer!
    var invalidated: Bool = false

    // Reference to data
    var modelController:ModelController = ModelController()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //modelController = UserDefaults.standard.object(forKey: "modelController") as! ModelController
        
        if makeNewVideo {
            // Show loading icon, and hide play and done buttons
            loadingIcon.isHidden = false
            loadingIcon.hidesWhenStopped = true
            buttons.isHidden = true
        } else {
            // Show play and done buttons, and hide loading icon
            loadingIcon.isHidden = true
            loadingIcon.hidesWhenStopped = true
            buttons.isHidden = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if makeNewVideo {
            // Start loading icon
            loadingIcon.startAnimating()
            
            // Reset timer
            if timer != nil {
                timer.invalidate()
                timer = nil
                invalidated = true
            }
            
            // Start loading timer
            invalidated = false
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timerOff), userInfo: nil, repeats: false)
        }
    }
    
    @objc func timerOff() {
        timer.invalidate()
        timer = nil
        invalidated = true
        
        // Stop loading icon
        loadingIcon.stopAnimating()
        
        // Make video
        makeVideo()
        
        // Show play and done buttons
        buttons.isHidden = false
    }
    
    func makeVideo() {
        // Get audio and text
        audioURL = modelController.audioURL
        for text in modelController.allText {
            allText.append(text)
        }
        
        // import video into data set
        
        // get file name, feedback, and url
        videoFileName = "Emperor's New Clothes"
        feedback = "Good job."
        
        makeNewVideo = false
    }
    
    @IBAction func playButton(_ sender: Any) {
        if let path = Bundle.main.path(forResource: videoFileName, ofType: "mp4") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            present(videoPlayer, animated: true, completion: {
                video.play()
            })
        }
    }

    
    /********** SEGUE FUNCTIONS **********/
    @IBAction func doneButton(_ sender: Any) {
        // Save video
        modelController.saveVideo(feedback: feedback, file: videoFileName)
        print("saved video")
        
        // Go to the Welcome scene
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //UserDefaults.standard.set(modelController, forKey: "modelController")
        
        // Update the modelController in the Welcome scene.
        if segue.destination is ViewController {
            // This is the first section and the first question.
            modelController.mySection = 0
            modelController.myQuestion = 0

            // Reset values
            modelController.currentRanges = []
            modelController.currentAttributes = []
            modelController.allText = []
            modelController.allRanges = []
            modelController.allAttributes = []

            // Update the modelController.
            let Destination = segue.destination as? ViewController
            Destination?.modelController = modelController
        }
    }
}
