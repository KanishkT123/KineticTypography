//
//  NewBookViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/3/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class NewBookViewController: UIViewController, UITextFieldDelegate {
    /********** LOCAL VARIABLES **********/
    // The text field that the user inputs the book title.
    @IBOutlet weak var titleBox: UITextField!
    
    // Error message
    @IBOutlet weak var error: UITextField!
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //modelController = UserDefaults.standard.object(forKey: "modelController") as! ModelController
        titleBox.delegate = self
        error.textColor = UIColor.clear
    }
    
    // When the user presses return, the text is submitted.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Submit text.
        textField.resignFirstResponder()
        
        return true
    }
    
    // When text field is going inactive (through tabbing or returning), it saves the title.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Save title to myBook.
        modelController.myBook = Book(file: textField.text!, sections: [])

        return true
    }

    
    /********** SEGUE FUNCTIONS **********/
    // When the user clicks the back button, it sends them to the TeacherWelcome scene.
    @IBAction func backButton(_ sender: Any) {
        // Go to the TeacherWelcome scene.
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    
    // When the user clicks the next button, it sends them to the NewBookDetails scene if a title has been entered. Otherwise, an error message is shown.
    @IBAction func nextButton(_ sender: Any) {
        if modelController.myBook.file == "" {
            error.textColor = UIColor.red
        } else {
            // Go to the NewBookDetails scene.
            self.performSegue(withIdentifier: "NewBookDetails", sender: self)
        }
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //UserDefaults.standard.set(modelController, forKey: "modelController")
        
        // Update the modelController in the TeacherWelcome scene.
        if segue.destination is TeacherWelcomeViewController {
            let Destination = segue.destination as? TeacherWelcomeViewController
            Destination?.modelController = modelController
        }

        // Update the modelController in the NewBookDetails scene.
        if segue.destination is NewBookDetailsViewController {
            let Destination = segue.destination as? NewBookDetailsViewController
            Destination?.modelController = modelController
        }
    }
}
