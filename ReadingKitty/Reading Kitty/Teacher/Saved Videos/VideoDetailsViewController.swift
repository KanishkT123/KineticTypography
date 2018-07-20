//
//  VideoDetailsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/13/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit
import AVKit

class VideoDetailsViewController: UIViewController {
    //////// Figure out export video button ////////
    /********** LOCAL VARIABLES **********/
    // Label
    @IBOutlet weak var videoLabel: UILabel!
    
    // Textbox
    @IBOutlet weak var feedbackBox: UITextView!
    
    // Video variables.
    var videoTitles:[String] = []
    
    // UserDefaults variables.
    var data:Data = Data()
    var library:Library = Library()
    
    
    /********** VIEW FUNCTIONS **********/
    // When view controller appears, set the correct video title as the header and the correct feedback as the infobox
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values.
        library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
        
        // Get video titles.
        for video:Video in library.videos {
            // Add each video title to videoTitles
            let videoTitle:String = "\(video.name) - \(video.bookTitle)"
            videoTitles.append(videoTitle)
        }
        
        // Set correct video title
        videoLabel.text = videoTitles[data.myVideo]
        videoLabel.baselineAdjustment = .alignCenters
        
        // Set correct feedback
        feedbackBox.text = library.videos[data.myVideo].feedback
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the SavedVideos scene
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "SavedVideos", sender: self)
    }
    
    // When user clicks the play button, it plays the video and send them to the Player scene
    @IBAction func playVideo(_ sender: Any) {
        // Get video
        let currentVideo = library.videos[data.myVideo]
        
        // Play video
        if let path = Bundle.main.path(forResource: currentVideo.file, ofType: "mp4") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            present(videoPlayer, animated: true, completion: {
                video.play()
            })
        }
    }
    
    // When user clicks the export button, it exports the video.
    @IBAction func exportButton(_ sender: Any) {
        // Get video
        let currentVideo = library.videos[data.myVideo]
        
        // Download video
        if let path = Bundle.main.path(forResource: currentVideo.file, ofType: "mp4") {
            // Do some stuff
            print("exporting doesn't work right now. the path is \(path)")
            
        }
    }
    
    // When user clicks the delete button, it removes the video from the saved videos list and sends them to the SavedVideos scene
    @IBAction func deleteButton(_ sender: Any) {
        // Delete video
        library.videos.remove(at: data.myVideo)
        UserDefaults.standard.set(library.toDictionary(), forKey: "library")
        
        // Go to SavedVideos
        self.performSegue(withIdentifier: "SavedVideos", sender: self)
    }
    
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in SavedVideos
        if segue.destination is SavedVideosViewController {
            let Destination = segue.destination as? SavedVideosViewController
            Destination?.data = data
        }
    }
}
