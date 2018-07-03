//
//  ReadingInstructionsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/26/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class ReadingInstructionsViewController: UIViewController {
    /********** LOCAL VARIABLES **********/
    // Color changing objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var goButton: UIButton!
    
    // Label
    @IBOutlet weak var bookTitle: UILabel!
    
    // Back data
    var myText: NSMutableAttributedString = NSMutableAttributedString(string: "")
    var mySeparator: String = ""
    var answerRanges: [NSRange] = []
    
    // Reference to data
    var modelController:ModelController = ModelController()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
        bookTitle.text = modelController.myBook.file
    }
    
    func updateColors() {
        background.backgroundColor = modelController.getColorBackground(color: modelController.myColor, opacity: 1.0)
        header.backgroundColor = modelController.getColorLight(color: modelController.myColor, opacity: 0.8)
        goButton.backgroundColor = modelController.getColorRegular(color: modelController.myColor, opacity: 1.0)
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the Graphics scene.
    @IBAction func backButton(_ sender: Any) {
        // Get previous text
        myText = modelController.allText.removeLast()
        
        // Get previous ranges and attributes
        modelController.currentRanges = modelController.allRanges.removeLast()
        modelController.currentAttributes = modelController.allAttributes.removeLast()
        
        // Get previous separator and answer ranges
        mySeparator = modelController.myBook.sections[modelController.mySection].separator
        answerRanges = modelController.currentRanges.last!
        
        // Go to Graphics scene.
        self.performSegue(withIdentifier: "Graphics", sender: self)
    }

    // When user clicks the audio button, it plays the audio.
    @IBAction func audioButton(_ sender: Any) {
        // Play audio.
        print("Play ReadingInstructions audio")
    }

    // When user clicks the go button, it sends them to the Reading scene.
    @IBAction func goButton(_ sender: Any) {
        // Go to the Reading scene.
        self.performSegue(withIdentifier: "Reading", sender: self)
    }

    // Pass shared data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in the Graphics scene.
        if segue.destination is GraphicsViewController {
            // Update the GraphicsmodelController.
            let Destination = segue.destination as? GraphicsViewController
            Destination?.modelController = modelController
            Destination?.myText = myText
            Destination?.answerRanges = answerRanges
            Destination?.mySeparator = mySeparator
        }
        
        // Update the modelController in the Reading scene.
        if segue.destination is ReadingViewController {
            let Destination = segue.destination as? ReadingViewController
            Destination?.modelController = modelController
        }
    }
}
