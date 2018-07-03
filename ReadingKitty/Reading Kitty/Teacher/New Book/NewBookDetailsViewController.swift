//
//  NewBookDetailsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/3/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class NewBookDetailsViewController: UIViewController {
    /********** LOCAL VARIABLES **********/
    // Header
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var details: UILabel!
    
    // Text
    @IBOutlet weak var textBox: UITextView!
    var currentSection: Int = 1
    
    // Separator
    
    // Question
    
    // Device
    
    // Answer
    
    
    // Saved book title
    var bookTitle: String = ""
    
    // Error message
    //@IBOutlet weak var error: UITextField!
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        // Save title.
        bookTitle = textField.text!
        
        return true
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When the user clicks the back button, it sends them to the ... scene.
    @IBAction func backButton(_ sender: Any) {
        // Go to the ... scene.
        //self.performSegue(withIdentifier: "", sender: self)
    }
    
    // When the user clicks the next button, it sends them to the ... scene if a title has been entered. Otherwise, an error message is shown.
    @IBAction func nextButton(_ sender: Any) {
        if bookTitle == "" {
            error.textColor = UIColor.red
        } else {
            // Go to the ... scene.
            //self.performSegue(withIdentifier: "", sender: self)
        }
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in ...
        if segue.destination is ViewController {
            let Destination = segue.destination as? ViewController
            Destination?.modelController = modelController
            // pass bookTitle
        }
    }
    

}
