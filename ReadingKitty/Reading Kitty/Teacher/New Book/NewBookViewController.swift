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
    
    // UserDefaults variables.
    var data:Data = Data()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set delegate.
        titleBox.delegate = self
        
        // Clear error.
        error.textColor = UIColor.clear
    }
    
    // When the user presses return, the text is submitted.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Submit text.
        textField.resignFirstResponder()
        
        return true
    }

    
    /********** SEGUE FUNCTIONS **********/
    // When the user clicks the back button, it sends them to the TeacherWelcome scene.
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    
    // When the user clicks the next button, it sends them to the NewBookDetails scene if a title has been entered. Otherwise, an error message is shown.
    @IBAction func nextButton(_ sender: Any) {
        if titleBox.text == "" {
            error.textColor = UIColor.red
        } else {
            // Save title to myBook.
            data.myBook = Book(file: titleBox.text!, level: 0, sections: [])
            // Go to the NewBookDetails scene.
            self.performSegue(withIdentifier: "NewBookDetails", sender: self)
        }
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the TeacherWelcome scene.
        if segue.destination is TeacherWelcomeViewController {
            let Destination = segue.destination as? TeacherWelcomeViewController
            Destination?.data = data
        }

        // Update the data in the NewBookDetails scene.
        if segue.destination is NewBookDetailsViewController {
            let Destination = segue.destination as? NewBookDetailsViewController
            Destination?.data = data
        }
    }
}
