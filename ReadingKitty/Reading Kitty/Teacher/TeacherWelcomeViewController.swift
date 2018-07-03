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
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the Welcome scene
    @IBAction func backButton(_ sender: Any) {
        // Go to Welcome
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
    // When user clicks on the levels button, it sends them to the TeacherLevels scene
    @IBAction func levelsButton(_ sender: Any) {
        // Go to TeacherLevels
        self.performSegue(withIdentifier: "TeacherLevels", sender: self)
    }
    
    // When user clicks on the saved videos button, it sends them to the SavedVideos scene
    @IBAction func savedVideosButton(_ sender: Any) {
        // Go to SavedVideos
        self.performSegue(withIdentifier: "SavedVideos", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in Welcome
        if segue.destination is ViewController {
            let Destination = segue.destination as? ViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelControlelr in TeacherLevels
        if segue.destination is TeacherLevelsViewController {
            let Destination = segue.destination as? TeacherLevelsViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelController in SavedVideos
        if segue.destination is SavedVideosViewController {
            let Destination = segue.destination as? SavedVideosViewController
            Destination?.modelController = modelController
        }
    }
}
