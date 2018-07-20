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
    var data:Data = Data()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update the color scheme.
        updateColors()
        
        // Set header.
        bookTitle.text = data.myBook.file
        bookTitle.baselineAdjustment = .alignCenters
    }
    
    func updateColors() {
        let colorScheme:Color = data.colors[data.myColor]
        background.backgroundColor = colorScheme.getColorBackground(opacity: 1.0)
        header.backgroundColor = colorScheme.getColorLight(opacity: 0.8)
        goButton.backgroundColor = colorScheme.getColorRegular(opacity: 1.0)
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the Graphics scene.
    @IBAction func backButton(_ sender: Any) {
        // Get previous text
        myText = data.allText.removeLast()
        
        // Get previous ranges and attributes
        data.currentRanges = data.allRanges.removeLast()
        data.currentAttributes = data.allAttributes.removeLast()
        
        // Get previous separator and answer ranges
        mySeparator = data.myBook.sections[data.mySectionNum].separator
        answerRanges = data.currentRanges.last!
        
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
        // Update the data in the Graphics scene.
        if segue.destination is GraphicsViewController {
            let Destination = segue.destination as? GraphicsViewController
            Destination?.data = data
            Destination?.myText = myText
            Destination?.answerRanges = answerRanges
            Destination?.mySeparator = mySeparator
        }

        // Update the data in the Reading scene.
        if segue.destination is ReadingViewController {
            let Destination = segue.destination as? ReadingViewController
            Destination?.data = data
        }
    }
}
