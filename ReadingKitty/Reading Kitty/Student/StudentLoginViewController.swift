//
//  StudentLoginViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/8/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class StudentLoginViewController: UIViewController, UITextFieldDelegate {
    /********** LOCAL VARIABLES **********/
    // Text field
    @IBOutlet weak var nameBox: UITextField!
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    // Button
    @IBOutlet weak var goButton: UIButton!
    
    // Color scheme objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var inputBackground: UIView!
    
    // Data
    var data:Data = Data()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reset name so an old name isn't used automatically.
        data.name = ""
        
        // Set delegates.
        nameBox.delegate = self
        
        // Update the color scheme.
        updateColors()
        
        // Make both labels the same size. nameLevel already has size constraints, so make colorLabel match.
        colorLabel.font = nameLabel.font
    }
    
    // Update the color scheme based on what color the user chose at the login.
    func updateColors() {
        let colorScheme:Color = data.colors[data.myColor]
        background.backgroundColor = colorScheme.getColorBackground(opacity: 1.0)
        inputBackground.backgroundColor = colorScheme.getColorDark(opacity: 0.8)
        nameBox.backgroundColor = colorScheme.getColorLight(opacity: 1.0)
        nameBox.textColor = colorScheme.getColorRegular(opacity: 1.0)
        goButton.backgroundColor = colorScheme.getColorRegular(opacity: 1.0)
    }
    
    // When a color is selected, update myColor and update colors in the scene
    @IBAction func redButton(_ sender: Any) {
        data.myColor = 0
        updateColors()
    }
    @IBAction func orangeButton(_ sender: Any) {
        data.myColor = 1
        updateColors()
    }
    @IBAction func yellowButton(_ sender: Any) {
        data.myColor = 2
        updateColors()
    }
    @IBAction func greenButton(_ sender: Any) {
        data.myColor = 3
        updateColors()
    }
    @IBAction func blueButton(_ sender: Any) {
        data.myColor = 4
        updateColors()
    }
    @IBAction func purpleButton(_ sender: Any) {
        data.myColor = 5
        updateColors()
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the Welcome scene
    @IBAction func backButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
    // The name that the user inputs gets saved. Go to next scene
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // When user clicks go button, it saves the name and goes to the StudentLevels scene if the student input a name
    @IBAction func goButton(_ sender: Any) {
        // Submit name.
        nameBox.resignFirstResponder()
        
        // If the user inputed a name, save the name and color, and go to StudentLevels.
        if nameBox.text != "" {
            data.name = nameBox.text!
            self.performSegue(withIdentifier: "StudentLevels", sender: self)
        }
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the Welcome scene.
        if segue.destination is ViewController {
            let Destination = segue.destination as? ViewController
            Destination?.data = data
        }

        // Update the data in the StudentLevels scene.
        if segue.destination is StudentLevelsViewController {
            let Destination = segue.destination as? StudentLevelsViewController
            Destination?.data = data
        }
    }
}
