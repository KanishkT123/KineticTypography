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
    // Text and video
    var compiledText:NSMutableAttributedString = NSMutableAttributedString(string: "")
    var audioURL:URL = URL(fileURLWithPath: "")
    var maxFrequency:Double = 0.0
    var minFrequency:Double = 0.0
    var videoFileName:String = ""
    var feedback:String = ""
    
    // Loading icon
    var makeNewVideo: Bool = false
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    // Buttons
    @IBOutlet weak var buttons: UIStackView!
    
    // Temporary timer
    var timer: Timer!
    var invalidated: Bool = false

    // UserDefault variables
    var data:Data = Data()
    var library:Library = Library()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values.
        library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
        
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
        // Get text
        for text in data.allText {
            compiledText.append(text)
        }
        
        // Get audio
        audioURL = data.audioURL
        maxFrequency = data.maxFrequency
        minFrequency = data.minFrequency
        let frequencyRange = maxFrequency - minFrequency
        
        // import video into data set
        
        // get file name, feedback, and url
        videoFileName = "Emperor's New Clothes"
        
        if frequencyRange < 50 {
            feedback = "Struggling reader."
        } else {
            feedback = "Strong reader."
        }
        
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
        let newVideo:Video = Video(name: data.name, bookTitle: data.myBook.file, feedback: feedback, file: videoFileName)
        library.videos.append(newVideo)
        UserDefaults.standard.set(library.toDictionary(), forKey: "library")
        
        // The next time a book is opened, the user will be on the first section and the first question.
        data.mySectionNum = 0
        data.myQuestionNum = 0
        
        // Reset the book values.
        data.currentRanges = []
        data.currentAttributes = []
        data.allText = []
        data.allRanges = []
        data.allAttributes = []
        
        // Go to the Welcome scene
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the Welcome scene.
        if segue.destination is ViewController {
            let Destination = segue.destination as? ViewController
            Destination?.data = data
        }
    }
}
