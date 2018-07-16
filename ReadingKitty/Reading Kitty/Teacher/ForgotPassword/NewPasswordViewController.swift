//
//  NewPasswordViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/14/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class NewPasswordViewController: UIViewController, UITextFieldDelegate {
    /********** LOCAL VARIABLES **********/
    // Textboxes
    @IBOutlet weak var newBox: UITextField!
    @IBOutlet weak var confirmBox: UITextField!
    @IBOutlet weak var errorNotice: UITextField!
    
    // Passwords
    var newPassword: String = ""
    var confirmPassword: String = ""
    
    // Reference to levels, books, and devices
    var modelController:ModelController = ModelController()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modelController = UserDefaults.standard.object(forKey: "modelController") as! ModelController
        newBox.delegate = self
        confirmBox.delegate = self
        errorNotice.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the SecurityQuestion scene
    @IBAction func backButton(_ sender: Any) {
        // Go to SecurityQuestion
        self.performSegue(withIdentifier: "SecurityQuestion", sender: self)
    }
    
    // When user presses return, end editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // submit password
        textField.resignFirstResponder()
        return true
    }
    
    // When text field is going inactive (through tabbing or returning)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Save password to respective variable
        if textField == newBox {
            newPassword = textField.text!
        } else if textField == confirmBox {
            confirmPassword = textField.text!
        }
        return true
    }
    
    // When user clicks the setPassword button, it checks if the passwords are the same, saves the new password, and send them to the TeacherWelcome scene
    @IBAction func setPassword(_ sender: Any) {
        // submit both textboxes
        newBox.resignFirstResponder()
        confirmBox.resignFirstResponder()
        newPassword = newBox.text!
        confirmPassword = confirmBox.text!
        
        // check if passwords match and don't equal ""
        if newPassword == confirmPassword && newPassword != "" {
            // save password
            modelController.password = newPassword
            
            // Go to TeacherWelcome
            self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
            
        } else if newPassword != confirmPassword {
            // show notification
            errorNotice.textColor = UIColor.red
            errorNotice.text = "Passwords must match."
            
            // erase both textboxes
            newBox.text = ""
            confirmBox.text = ""
            
            // erase both passwords
            newPassword = ""
            confirmPassword = ""
            
        } else if newPassword == "" {
            // show notification
            errorNotice.textColor = UIColor.red
            errorNotice.text = "You must have a password."
            
            // erase both textboxes
            newBox.text = ""
            confirmBox.text = ""
            
            // erase both passwords
            newPassword = ""
            confirmPassword = ""
        }
    }
    
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(modelController, forKey: "modelController")
        
//        // Update the modelController in SecurityQuestion
//        if segue.destination is SecurityQuestionViewController {
//            let Destination = segue.destination as? SecurityQuestionViewController
//            Destination?.modelController = modelController
//        }
//
//        // Update the modelController in TeacherWelcome
//        if segue.destination is TeacherWelcomeViewController {
//            let Destination = segue.destination as? TeacherWelcomeViewController
//            Destination?.modelController = modelController
//        }
    }
}
