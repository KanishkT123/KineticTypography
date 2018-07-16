//
//  TeacherLoginViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/8/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class TeacherLoginViewController: UIViewController, UITextFieldDelegate { 
    /********** LOCAL VARIABLES **********/
    // The text field that the user inputs their password
    @IBOutlet weak var passwordBox: UITextField!
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modelController = UserDefaults.standard.object(forKey: "modelController") as! ModelController
        passwordBox.delegate = self
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it sends them to the Welcome scene.
    @IBAction func backButton(_ sender: UIButton) {
        // Go to the Welcome scene.
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
    // When the user presses return, the text is submitted.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Submit text.
        textField.resignFirstResponder()
        
        return true
    }
    
    // When text field is going inactive (through tabbing or returning), it sends them to the TeacherWelcome scene if the password is correct.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Check if the password is correct.
        if modelController.checkPassword(attemptedPassword: textField.text!) {
            //Go to the TeacherWelcome scene.
            self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
        }
        
        return true
    }
    
    // If user clicks on the forgot password button, it send them to the SecurityQuestion scene.
    @IBAction func forgotPassword(_ sender: Any) {
        // Go to SecurityQuestion
        self.performSegue(withIdentifier: "SecurityQuestion", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(modelController, forKey: "modelController")
        
//        // Update the modelController in Welcome
//        if segue.destination is ViewController {
//            let Destination = segue.destination as? ViewController
//            Destination?.modelController = modelController
//        }
//
//        // Update the modelController in TeacherWelcome
//        if segue.destination is TeacherWelcomeViewController {
//            let Destination = segue.destination as? TeacherWelcomeViewController
//            Destination?.modelController = modelController
//        }
//
//        // Update the modelController in SecurityQuestion
//        if segue.destination is SecurityQuestionViewController {
//            let Destination = segue.destination as? SecurityQuestionViewController
//            Destination?.modelController = modelController
//        }
    }
}
