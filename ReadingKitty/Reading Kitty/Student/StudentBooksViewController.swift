//
//  StudentBooksViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/18/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class StudentBooksViewController: UIViewController {
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
            goToQuestion()
        }
    }
    
    func updateColors() {
        background.backgroundColor = modelController.getColorBackground(color: modelController.myColor, opacity: 1.0)
        header.backgroundColor = modelController.getColorLight(color: modelController.myColor, opacity: 0.8)
    }
    
    func goToQuestion() {
        tableSelected = false
        self.performSegue(withIdentifier: "Question", sender: self)
    }
    

    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the StudentLogin scene
    @IBAction func backButton(_ sender: Any) {
        // Go to StudentLogin
        self.performSegue(withIdentifier: "StudentLevels", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in StudentLevels
        if segue.destination is StudentLevelsViewController {
            let Destination = segue.destination as? StudentLevelsViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelController in QuestionInstructions
        if segue.destination is QuestionViewController {
            let Destination = segue.destination as? QuestionViewController
            Destination?.modelController = modelController
        }
        
        // Always update StudentBooksTable
        if segue.destination is StudentBooksTableViewController {
            let Destination = segue.destination as? StudentBooksTableViewController
            Destination?.modelController = modelController
        }
    }
}
