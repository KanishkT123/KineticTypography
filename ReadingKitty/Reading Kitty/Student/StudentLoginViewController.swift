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
    
    // Color changing objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var inputBackground: UIView!
    
    // Reference to data
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameBox.delegate = self
        updateColors()
        modelController = UserDefaults.standard.object(forKey: "modelController") as! ModelController
        
        // Make both labels the same size. nameLevel already has size constraints, so make colorLabel match
        colorLabel.font = nameLabel.font
        
        // Reset name. This way we can make sure the user submits a name every time, rather than using an old name.
        modelController.name = ""
    }
    
    // Update the color scheme based on what color the user chose at the login
    func updateColors() {
        background.backgroundColor = modelController.getColorBackground(color: modelController.myColor, opacity: 1.0)
        inputBackground.backgroundColor = modelController.getColorDark(color: modelController.myColor, opacity: 0.8)
        nameBox.backgroundColor = modelController.getColorLight(color: modelController.myColor, opacity: 1.0)
        nameBox.textColor = modelController.getColorRegular(color: modelController.myColor, opacity: 1.0)
        goButton.backgroundColor = modelController.getColorRegular(color: modelController.myColor, opacity: 1.0)
    }
    
    // When a color is selected, update myColor and update colors in the scene
    @IBAction func redButton(_ sender: Any) {
        modelController.myColor = 0
        updateColors()
    }
    @IBAction func orangeButton(_ sender: Any) {
        modelController.myColor = 1
        updateColors()
    }
    @IBAction func yellowButton(_ sender: Any) {
        modelController.myColor = 2
        updateColors()
    }
    @IBAction func greenButton(_ sender: Any) {
        modelController.myColor = 3
        updateColors()
    }
    @IBAction func blueButton(_ sender: Any) {
        modelController.myColor = 4
        updateColors()
    }
    @IBAction func purpleButton(_ sender: Any) {
        modelController.myColor = 5
        updateColors()
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the Welcome scene
    @IBAction func backButton(_ sender: UIButton) {
        // Go to Welcome
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
    // The name that the user inputs gets saved. Go to next scene
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Submit
        textField.resignFirstResponder()

        return true
    }
    
    // When user clicks go button, it saves the name and goes to the StudentLevels scene if the student input a name
    @IBAction func goButton(_ sender: Any) {
        // Submit name
        nameBox.resignFirstResponder()
        
        // Save name
        modelController.updateName(newName: nameBox.text!)
        
        // If the user inputed a name, go to StudentLevels
        if modelController.name != "" {
            self.performSegue(withIdentifier: "StudentLevels", sender: self)
        }
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(modelController, forKey: "modelController")
        
//        // Update the modelController in the Welcome scene.
//        if segue.destination is ViewController {
//            let Destination = segue.destination as? ViewController
//            Destination?.modelController = modelController
//        }
//
//        // Update the modelController in the StudentLevels scene.
//        if segue.destination is StudentLevelsViewController {
//            let Destination = segue.destination as? StudentLevelsViewController
//            Destination?.modelController = modelController
//        }
    }
}
