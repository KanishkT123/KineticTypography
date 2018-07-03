//
//  SavedVideosViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/8/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class SavedVideosViewController: UIViewController {
    /********** LOCAL VARIABLES **********/
    // Table details
    var tableSelected:Bool = false
    
    // Reference to levels, books, and devices
    var modelController:ModelController = ModelController()
    
    /********** VIEW FUNCTIONS **********/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tableSelected {
            goToVideoDetails()
        }
    }
    
    func goToVideoDetails() {
        tableSelected = false
        print("Going to video details")
        self.performSegue(withIdentifier: "VideoDetails", sender: self)
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the TeacherWelcome scene
    @IBAction func backButton(_ sender: Any) {
        // Go to TeacherWelcome
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in TeacherWelcome
        if segue.destination is TeacherWelcomeViewController {
            let Destination = segue.destination as? TeacherWelcomeViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelController in VideoDetails
        if segue.destination is VideoDetailsViewController {
            let Destination = segue.destination as? VideoDetailsViewController
            Destination?.modelController = modelController
        }
        
        // Always update SavedVideosTable
        if segue.destination is SavedVideosTableViewController {
            let Destination = segue.destination as? SavedVideosTableViewController
            Destination?.modelController = modelController
        }
    }
}
