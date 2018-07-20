//
//  ReadingViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/26/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ReadingViewController: UIViewController, UITextViewDelegate, AVAudioRecorderDelegate {
    /********** LOCAL VARIABLES **********/
    // Color changing objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    
    // Book objects
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookText: UITextView!
    
    // Buttons
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // Audio objects
    var isRecording:Bool = false
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    // Scrollbar timer
    var scrollTimer: Timer!
    var invalidated: Bool = false
    
    // UserDefault variables
    var data:Data = Data()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update the color scheme.
        updateColors()
        
        // Set delegates.
        bookText.delegate = self
        bookText.isSelectable = false
        bookText.isEditable = false
        
        // Set header.
        bookTitle.text = data.myBook.file
        bookTitle.baselineAdjustment = .alignCenters
        
        // Update the book text.
        let tempText: NSMutableAttributedString = NSMutableAttributedString(string: "")
        for text in data.allText {
            tempText.append(text)
        }
        bookText.attributedText = tempText
        
        // Hide stop button
        stopButton.isHidden = true
        stopButton.isEnabled = false
        
        // Show start button
        startButton.isHidden = false
        startButton.isEnabled = true
        
        // Start at top of text
        bookText.scrollsToTop = true
        
        // Reset timer
        if scrollTimer != nil {
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
        }
        
        // Start flashing indicator
        invalidated = false
        flashIndicator()
        scrollTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(flashIndicator), userInfo: nil, repeats: true)
        
        // Audio stuff
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                              AVEncoderBitRateKey: 16,
                              AVNumberOfChannelsKey: 2,
                              AVSampleRateKey: 44100.0] as [String : Any]
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    func updateColors() {
        let colorScheme:Color = data.colors[data.myColor]
        background.backgroundColor = colorScheme.getColorBackground(opacity: 1.0)
        header.backgroundColor = colorScheme.getColorLight(opacity: 0.8)
    }
    
    @objc func flashIndicator() {
        if !invalidated {
            bookText.flashScrollIndicators()
        }
    }
    
    
    /********** AUDIO FUNCTIONS **********/
    // When the user clicks the start button, start recording and switch visible button to the stop button.
    @IBAction func startButton(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            // Hide start button
            startButton.isHidden = true
            startButton.isEnabled = false
            
            // Show stop button
            stopButton.isHidden = false
            stopButton.isEnabled = true
            
            // Record audio
            audioRecorder?.record()
        }
    }
    
    // When the user clicks the stop button, stop and save recording, and switch visible buttons to the restart button and the save button.
    @IBAction func stopButton(_ sender: Any) {
        // Stop recording
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            print("error 1")
        }
        print("got here")
        // Save audio
        data.audioURL = (audioRecorder?.url)!
        
        // Go to the VideoPlayer scene
        goToVideoPlayer()
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When the user clicks the back button, it sends them to the ReadingInstructions scene.
    @IBAction func backButton(_ sender: Any) {
        // Stop timer
        scrollTimer.invalidate()
        scrollTimer = nil
        invalidated = true
        
        // Go to the ReadingInstructions scene.
        self.performSegue(withIdentifier: "ReadingInstructions", sender: self)
    }
    
    func goToVideoPlayer() {
        // Stop timer
        scrollTimer.invalidate()
        scrollTimer = nil
        invalidated = true
        
        // Go to the VideoPlayer scene
        self.performSegue(withIdentifier: "VideoPlayer", sender: self)
    }
    
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the VideoPlayer scene.
        if segue.destination is VideoPlayerViewController {
            let Destination = segue.destination as? VideoPlayerViewController
            Destination?.data = data
            Destination?.makeNewVideo = true
        }

        // Update the data in the ReadingInstructions scene.
        if segue.destination is ReadingInstructionsViewController {
            let Destination = segue.destination as? ReadingInstructionsViewController
            Destination?.data = data
        }
    }
}
