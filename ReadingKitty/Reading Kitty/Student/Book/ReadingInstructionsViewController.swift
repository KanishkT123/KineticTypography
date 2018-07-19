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
    
    // UserDefault variables
    var myColor:Int = 0
    var myBook:Book = Book(file: "", sections: [])
    var mySectionNum:Int = 0
    var currentRanges:[[NSRange]] = []
    var currentAttributes:[[NSAttributedStringKey : Any]] = []
    var allText:[NSMutableAttributedString] = []
    var allRanges:[[[NSRange]]] = []
    var allAttributes:[[[NSAttributedStringKey : Any]]] = []
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values.
        myColor = UserDefaults.standard.object(forKey: "myColor") as! Int
        myBook = UserDefaults.standard.object(forKey: "myBook") as! Book
        mySectionNum = UserDefaults.standard.object(forKey: "mySectionNum") as! Int
        currentRanges = UserDefaults.standard.object(forKey: "currentRanges") as! [[NSRange]]
        currentAttributes = UserDefaults.standard.object(forKey: "currentAttributes") as! [[NSAttributedStringKey : Any]]
        allText = UserDefaults.standard.object(forKey: "allText") as! [NSMutableAttributedString]
        allRanges = UserDefaults.standard.object(forKey: "allRanges") as! [[[NSRange]]]
        allAttributes = UserDefaults.standard.object(forKey: "allAttributes") as! [[[NSAttributedStringKey : Any]]]
        
        // Update the color scheme.
        updateColors()
        
        // Set header.
        bookTitle.text = myBook.file
        bookTitle.baselineAdjustment = .alignCenters
    }
    
    func updateColors() {
        background.backgroundColor = getColorBackground(color: myColor, opacity: 1.0)
        header.backgroundColor = getColorLight(color: myColor, opacity: 0.8)
        goButton.backgroundColor = getColorRegular(color: myColor, opacity: 1.0)
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the Graphics scene.
    @IBAction func backButton(_ sender: Any) {
        // Get previous text
        myText = allText.removeLast()
        UserDefaults.standard.set(allText, forKey: "allText")
        
        // Get previous ranges and attributes
        currentRanges = allRanges.removeLast()
        currentAttributes = allAttributes.removeLast()
        UserDefaults.standard.set(currentRanges, forKey: "currentRanges")
        UserDefaults.standard.set(currentAttributes, forKey: "currentAttributes")
        UserDefaults.standard.set(allRanges, forKey: "allRanges")
        UserDefaults.standard.set(allAttributes, forKey: "allAttributes")
        
        // Get previous separator and answer ranges
        mySeparator = myBook.sections[mySectionNum].separator
        answerRanges = currentRanges.last!
        
        // Go to the Graphics scene.
        self.performSegue(withIdentifier: "Graphics", sender: self)
    }

    // When user clicks the audio button, it plays the audio.
    @IBAction func audioButton(_ sender: Any) {
        // Play audio.
        print("Play ReadingInstructions audio")
    }

    // When user clicks the go button, it sends them to the Reading scene.
    @IBAction func goButton(_ sender: Any) {
        self.performSegue(withIdentifier: "Reading", sender: self)
    }

    // Pass shared data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //UserDefaults.standard.set(modelController, forKey: "modelController")
        
        // Update the modelController in the Graphics scene.
        if segue.destination is GraphicsViewController {
            let Destination = segue.destination as? GraphicsViewController
            //Destination?.modelController = modelController
            Destination?.myText = myText
            Destination?.answerRanges = answerRanges
            Destination?.mySeparator = mySeparator
        }

//        // Update the modelController in the Reading scene.
//        if segue.destination is ReadingViewController {
//            let Destination = segue.destination as? ReadingViewController
//            Destination?.modelController = modelController
//        }
    }
}
