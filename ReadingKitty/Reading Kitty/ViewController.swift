//
//  ViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/4/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /********** LOCAL VARIABLES **********/
//    // Reference to levels, books, and devices
//    var modelController = ModelController()
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the student button, it sends them to the StudentLogin scene
    @IBAction func studentButton(_ sender: UIButton) {
        // Go to the StudentLogin scene.
        self.performSegue(withIdentifier: "StudentLogin", sender: self)
    }
    
    // When user clicks the teacher button, it sends them to the TeacherLogin scene
    @IBAction func teacherButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "TeacherLogin", sender: self)
    }
//
//    // Passing data
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //UserDefaults.standard.set(modelController, forKey: "modelController")
//
//        // Update the modelController in StudentLogin
//        if segue.destination is StudentLoginViewController {
//            let Destination = segue.destination as? StudentLoginViewController
//            Destination?.modelController = modelController
//        }
//
//        // Update the modelController in TeacherLogin
//        if segue.destination is TeacherLoginViewController {
//            let Destination = segue.destination as? TeacherLoginViewController
//            Destination?.modelController = modelController
//        }
//    }
}

