//
//  StudentLevelsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/15/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class StudentLevelsViewController: UIViewController {
    /********** LOCAL VARIABLES **********/
    // Color changing objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    
    // Table details
    var tableSelected:Bool = false
    
    // Reference to data
    var modelController:ModelController = ModelController()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
        
        if tableSelected {
            goToStudentBooks()
        }
    }
    
    func updateColors() {
        background.backgroundColor = modelController.getColorBackground(color: modelController.myColor, opacity: 1.0)
        header.backgroundColor = modelController.getColorLight(color: modelController.myColor, opacity: 0.8)
    }
    
    func goToStudentBooks() {
        tableSelected = false
        self.performSegue(withIdentifier: "StudentBooks", sender: self)
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the StudentLogin scene
    @IBAction func backButton(_ sender: Any) {
        // Go to StudentLogin
        self.performSegue(withIdentifier: "StudentLogin", sender: self)
    }

    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in StudentLogin
        if segue.destination is StudentLoginViewController {
            let Destination = segue.destination as? StudentLoginViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelController in StudentBooks
        if segue.destination is StudentBooksViewController {
            let Destination = segue.destination as? StudentBooksViewController
            Destination?.modelController = modelController
        }

        // Always update StudentLevelsTable
        if segue.destination is StudentLevelsTableViewController {
            let Destination = segue.destination as? StudentLevelsTableViewController
            Destination?.modelController = modelController
        }
    }
}
