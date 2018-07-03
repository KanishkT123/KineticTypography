//
//  LevelDetailsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/11/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

var updateModelController:ModelController = ModelController()

class LevelDetailsViewController: UIViewController {
    /********** LOCAL VARIABLES **********/
    // Label
    @IBOutlet weak var readingLabel: UILabel!
    
    // Reference to levels, books, and devices
    var modelController:ModelController = ModelController()

    
    /********** VIEW FUNCTIONS **********/
    // When view controller appears, set the correct level as the header
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readingLabel.text = modelController.getReadingLevel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the TeacherLevels scene
    @IBAction func backButton(_ sender: Any) {
        // Go to TeacherLevels
        self.performSegue(withIdentifier: "TeacherLevels", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in LiteraryDevicesTable
        if segue.destination is LiteraryDevicesTableViewController {
            let Destination = segue.destination as? LiteraryDevicesTableViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelController in TeacherBooksTable
        if segue.destination is TeacherBooksTableViewController {
            let Destination = segue.destination as? TeacherBooksTableViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelController in TeacherLevels
        if segue.destination is TeacherLevelsViewController {
            let Destination = segue.destination as? TeacherLevelsViewController
            Destination?.modelController = modelController
        }
        
        // Always update LiteraryDevicesTable
        if segue.destination is LiteraryDevicesTableViewController {
            let Destination = segue.destination as? LiteraryDevicesTableViewController
            Destination?.modelController = modelController
        }
        
        // Always update TeacherBooksTable
        if segue.destination is TeacherBooksTableViewController {
            let Destination = segue.destination as? TeacherBooksTableViewController
            Destination?.modelController = modelController
        }
    }
}
