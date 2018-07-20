//
//  TeacherWelcomeViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/13/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class TeacherWelcomeViewController: UIViewController {
    /********** LOCAL VARIABLES **********/
    
    var data:Data = Data()
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the Welcome scene.
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
    // When user clicks on the levels button, it sends them to the TeacherLevels scene.
    @IBAction func levelsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "TeacherLevels", sender: self)
    }
    
    // When user clicks on the new book button, it sends them to the NewBook scene.
    @IBAction func newBookButton(_ sender: Any) {
        self.performSegue(withIdentifier: "NewBook", sender: self)
    }
    
    // When user clicks on the saved videos button, it sends them to the SavedVideos scene.
    @IBAction func savedVideosButton(_ sender: Any) {
        self.performSegue(withIdentifier: "SavedVideos", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in Welcome
        if segue.destination is ViewController {
            let Destination = segue.destination as? ViewController
            Destination?.data = data
        }

        // Update the data in TeacherLevels
        if segue.destination is TeacherLevelsViewController {
            let Destination = segue.destination as? TeacherLevelsViewController
            Destination?.data = data
        }

        // Update the data in NewBook
        if segue.destination is NewBookViewController {
            let Destination = segue.destination as? NewBookViewController
            Destination?.data = data
        }

        // Update the data in SavedVideos
        if segue.destination is SavedVideosViewController {
            let Destination = segue.destination as? SavedVideosViewController
            Destination?.data = data
        }
    }
}
