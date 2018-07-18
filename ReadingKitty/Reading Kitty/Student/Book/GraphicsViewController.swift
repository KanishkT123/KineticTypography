//
//  GraphicsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/22/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class GraphicsViewController: UIViewController, UITextViewDelegate {
    /********** LOCAL VARIABLES **********/
    // Color changing objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var doneButton: UIView!
    
    // Book info
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookText: UITextView!
    
    // Current text, location of answers, and color
    var myText:NSMutableAttributedString = NSMutableAttributedString(string: "")
    var answerRanges: [NSRange] = []
    var mySeparator: String = ""
    var myColor:UIColor = UIColor.black
    var newAttributes:[NSAttributedStringKey:Any] = [:]
    
    // Scrollbar timer
    var scrollTimer: Timer!
    var invalidated: Bool = false
    
    // Color changing buttons
    @IBOutlet weak var bigButton: UIButton!
    @IBOutlet weak var highlightButton: UIButton!
    @IBOutlet weak var shadowButton: UIButton!
    @IBOutlet weak var smallButton: UIButton!
    @IBOutlet weak var underlineButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    var buttonsPressed:[Bool] = [false, false, false, false, false]
    var buttonsColor:[UIColor] = [UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.black]
    
    // Selection options
    @IBOutlet weak var pickColor: UIStackView!
    @IBOutlet weak var pickGraphics: UIStackView!
    @IBOutlet weak var nextButtons: UIStackView!
    var pickingColor: Bool = true
    
    // Reference to data
    var modelController:ModelController = ModelController()

    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //modelController = UserDefaults.standard.object(forKey: "modelController") as! ModelController
        
        // Set the color scheme (including myColor)
        updateColors()
        
        // Show color options and go button
        pickColor.isHidden = false
        goButton.isHidden = false
        
        // Hide graphics options and next buttons
        pickGraphics.isHidden = true
        nextButtons.isHidden = true
        
        // Set the book title.
        bookTitle.text = modelController.myBook.file
        bookTitle.baselineAdjustment = .alignCenters
        
        // Allow the book text to be edited.
        bookText.delegate = self
        bookText.isEditable = false
        
        // Remove the link and color attributes from the question scene, and add the previously added attributes.
        let myRange:NSRange = NSMakeRange(0, myText.length)
        myText.removeAttribute(.link, range: myRange)
        myText.addAttribute(.foregroundColor, value: UIColor.black, range: myRange)
        addAllAttributes()
        bookText.attributedText = myText
        
        // Start at top of text
        bookText.scrollsToTop = true
        
        // Reset timer
        if scrollTimer != nil {
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
        }
        
        // Start flashing indicator
        invalidated = false
        flashIndicator()
        scrollTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(flashIndicator), userInfo: nil, repeats: true)
    }
    
    // Updates the color scheme of the scene.
    func updateColors() {
        background.backgroundColor = modelController.getColorBackground(color: modelController.myColor, opacity: 1.0)
        header.backgroundColor = modelController.getColorLight(color: modelController.myColor, opacity: 0.8)
        goButton.backgroundColor = modelController.getColorRegular(color: modelController.myColor, opacity: 1.0)
        againButton.backgroundColor = modelController.getColorRegular(color: modelController.myColor, opacity: 1.0)
        doneButton.backgroundColor = modelController.getColorRegular(color: modelController.myColor, opacity: 1.0)
        myColor = modelController.getColorRegular(color: modelController.myColor, opacity: 1.0)
    }
    
    // Update the attributes of the buttons
    func updateButtons() {
        // The big, small, and color buttons will have myColor text.
        bigButton.setTitleColor(myColor, for: .normal)
        smallButton.setTitleColor(myColor, for: .normal)
        colorButton.setTitleColor(myColor, for: .normal)
        
        // The highlight button will have a myColor highlight and have black text. If myColor is black, the text will be white so it is visible.
        var textColor:UIColor = UIColor.black
        if myColor == UIColor.black {
            textColor = UIColor.white
        }
        let highlight:NSMutableAttributedString = NSMutableAttributedString(string: "Highlight")
        highlight.addAttribute(.backgroundColor, value: myColor, range: NSMakeRange(0, highlight.length))
        highlight.addAttribute(.foregroundColor, value: textColor, range: NSMakeRange(0, highlight.length))
        highlightButton.setAttributedTitle(highlight, for: .normal)
        
        // The shadow button will have a myColor shadow and have black text.
        let newShadow:NSShadow = NSShadow()
        newShadow.shadowBlurRadius = 3
        newShadow.shadowOffset = CGSize(width: 3, height: 3)
        newShadow.shadowColor = myColor
        let shadow:NSMutableAttributedString = NSMutableAttributedString(string: "Shadow")
        shadow.addAttribute(.shadow, value: newShadow, range: NSMakeRange(0, shadow.length))
        shadow.addAttribute(.foregroundColor, value: UIColor.black, range: NSMakeRange(0, shadow.length))
        shadowButton.setAttributedTitle(shadow, for: .normal)
        
        // The underline button will have a myColor underline and have black text.
        let underline:NSMutableAttributedString = NSMutableAttributedString(string: "Underline")
        underline.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, underline.length))
        underline.addAttribute(.underlineColor, value: myColor, range: NSMakeRange(0, underline.length))
        underline.addAttribute(.foregroundColor, value: UIColor.black, range: NSMakeRange(0, underline.length))
        underlineButton.setAttributedTitle(underline, for: .normal)
    }
    
    // Makes previously saved attributes visible.
    func addAllAttributes() {
        for question:Int in 0..<modelController.currentRanges.count {
            for range:NSRange in modelController.currentRanges[question] {
                myText.addAttributes(modelController.currentAttributes[question], range: range)
            }
        }
    }
    
    @objc func flashIndicator() {
        if !invalidated {
            bookText.flashScrollIndicators()
        }
    }
    
    /********** COLOR FUNCTIONS **********/
    // When a color is selected, update myColor and update the color of the go button
    @IBAction func redButton(_ sender: Any) {
        myColor = modelController.getColorRegular(color: 0, opacity: 1.0)
        goButton.backgroundColor = myColor
        goButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @IBAction func orangeButton(_ sender: Any) {
        myColor = modelController.getColorRegular(color: 1, opacity: 1.0)
        goButton.backgroundColor = myColor
        goButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @IBAction func yellow(_ sender: Any) {
        myColor = modelController.getColorRegular(color: 2, opacity: 1.0)
        goButton.backgroundColor = myColor
        goButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @IBAction func greenButton(_ sender: Any) {
        myColor = modelController.getColorRegular(color: 3, opacity: 1.0)
        goButton.backgroundColor = myColor
        goButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @IBAction func blueButton(_ sender: Any) {
        myColor = modelController.getColorRegular(color: 4, opacity: 1.0)
        goButton.backgroundColor = myColor
        goButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @IBAction func purpleButton(_ sender: Any) {
        myColor = modelController.getColorRegular(color: 5, opacity: 1.0)
        goButton.backgroundColor = myColor
        goButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @IBAction func blackButton(_ sender: Any) {
        myColor = UIColor.black
        goButton.backgroundColor = myColor
        goButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    // When the go button is pressed, if we just finished picking the color, show graphics options. Otherwise show next buttons
    @IBAction func goButton(_ sender: Any) {
        if !pickColor.isHidden {
            // Hide color options
            pickColor.isHidden = true
            
            // Show graphics options
            pickGraphics.isHidden = false
            updateButtons()
        } else {
            // Hide graphics options and go button
            pickGraphics.isHidden = true
            goButton.isHidden = true
            
            // Show next buttons
            nextButtons.isHidden = false
        }
    }
    
    
    /********** GRAPHICS FUNCTIONS **********/
    // Makes the font size of the answers 60 when the big button is pressed, and makes the font size of the answers 35 when the big button is unpressed.
    @IBAction func bigButton(_ sender: Any) {
        // The small button is automatically unpressed when the big button has been pressed.
        buttonsPressed[3] = false
        
        // The new font size of the answers
        var newSize:CGFloat = 0.0
        
        // Check if the button has been unpressed.
        if buttonsPressed[0] && buttonsColor[0] == myColor{
            // The big button has been unpressed.
            buttonsPressed[0] = false
            
            // Set the new size of the answers.
            newSize = 35.0
        } else {
            // The big button has been pressed with the color myColor.
            buttonsPressed[0] = true
            buttonsColor[0] = myColor
            
            // Set the new size of the answers.
            newSize = 60.0
        }
        
        // Update the size and color in newAttributes and myText.
        newAttributes[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: newSize)
        newAttributes[NSAttributedStringKey.foregroundColor] = myColor
        for range:NSRange in answerRanges {
            myText.addAttributes(newAttributes, range: range)
        }
        
        // Update the book text.
        bookText.attributedText = myText
    }
    
    // Highlights the answers when the highlight button is pressed.
    @IBAction func highlightButton(_ sender: Any) {
        // Check if the button has been unpressed.
        if buttonsPressed[1] && buttonsColor[1] == myColor{
            // The highlight button has been unpressed.
            buttonsPressed[1] = false
            
            // Remove the highlight in newAttributes and myText.
            newAttributes.removeValue(forKey: NSAttributedStringKey.backgroundColor)
            for range:NSRange in answerRanges {
                myText.removeAttribute(.backgroundColor, range: range)
            }
        } else {
            // The highlight button has been pressed with the color myColor.
            buttonsPressed[1] = true
            buttonsColor[1] = myColor
            
            // Add a highlight to newAttributes and myText.
            newAttributes[NSAttributedStringKey.backgroundColor] = myColor
            for range:NSRange in answerRanges {
                myText.addAttributes(newAttributes, range: range)
            }
        }
        
        // Update the book text.
        bookText.attributedText = myText
    }
    
    // Adds a shadow to the answers when the shadow button is pressed.
    @IBAction func shadowButton(_ sender: Any) {
        // Check if the button has been unpressed.
        if buttonsPressed[2] && buttonsColor[2] == myColor{
            // The shadow button has been unpressed.
            buttonsPressed[2] = false
            
            // Remove the shadow in newAttributes and myText.
            newAttributes.removeValue(forKey: NSAttributedStringKey.shadow)
            for range:NSRange in answerRanges {
                myText.removeAttribute(.shadow, range: range)
            }
        } else {
            // The shadow button has been pressed with the color myColor.
            buttonsPressed[2] = true
            buttonsColor[2] = myColor
            
            // Create a shadow.
            let newShadow:NSShadow = NSShadow()
            newShadow.shadowBlurRadius = 3
            newShadow.shadowOffset = CGSize(width: 3, height: 3)
            newShadow.shadowColor = myColor
            
            // Add the shadow to newAttributes and myText.
            newAttributes[NSAttributedStringKey.shadow] = newShadow
            for range:NSRange in answerRanges {
                myText.addAttributes(newAttributes, range: range)
            }
        }
        
        // Update the book text.
        bookText.attributedText = myText
    }
    
    // Makes the font size of the answers 20 when the small button is pressed, and makes the font size of the answers 35 when the big button is unpressed.
    @IBAction func smallButton(_ sender: Any) {
        // The big button is automatically unpressed when the small button has been pressed.
        buttonsPressed[0] = false
        
        // The new font size of the answers.
        var newSize:CGFloat = 0.0
        
        // Check if the button has been unpressed.
        if buttonsPressed[3] && buttonsColor[3] == myColor{
            // The small button has been unpressed.
            buttonsPressed[3] = false
            
            // Set the new size of the answers.
            newSize = 35.0
        } else {
            // The small button has been pressed with the color myColor.
            buttonsPressed[3] = true
            buttonsColor[3] = myColor
            
            // Set the new size of the answers.
            newSize = 20.0
        }
        
        // Update the size and color in newAttributes and myText.
        newAttributes[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: newSize)
        newAttributes[NSAttributedStringKey.foregroundColor] = myColor
        for range:NSRange in answerRanges {
            myText.addAttributes(newAttributes, range: range)
        }
        
        // Update the book text.
        bookText.attributedText = myText
    }
    
    // Underlines the answers when the underline button is pressed.
    @IBAction func underlineButton(_ sender: Any) {
        // Check if the button has been unpressed.
        if buttonsPressed[4] && buttonsColor[4] == myColor{
            // The underline button has been unpressed.
            buttonsPressed[4] = false
            
            // Remove the underline in newAttributes and myText.
            newAttributes.removeValue(forKey: NSAttributedStringKey.underlineStyle)
            for range:NSRange in answerRanges {
                myText.removeAttribute(.underlineStyle, range: range)
            }
        } else {
            // The underline button has been pressed with the color myColor.
            buttonsPressed[4] = true
            buttonsColor[4] = myColor
            
            // Add an underline to newAttributes and myText.
            newAttributes[NSAttributedStringKey.underlineStyle] = NSUnderlineStyle.styleSingle.rawValue
            newAttributes[NSAttributedStringKey.underlineColor] = myColor
            for range:NSRange in answerRanges {
                myText.addAttributes(newAttributes, range: range)
            }
        }
        
        // Update the book text.
        bookText.attributedText = myText
    }
    
    // Changes the text color of the answers when the color button is pressed.
    @IBAction func colorButton(_ sender: Any) {
        // The color button automatically sets the saved colors of the big button and the small button to myColor.
        buttonsColor[0] = myColor
        buttonsColor[3] = myColor
        
        // Update the text color in newAttributes and myText.
        newAttributes[NSAttributedStringKey.foregroundColor] = myColor
        for range:NSRange in answerRanges {
            myText.addAttributes(newAttributes, range: range)
        }
        
        // Update the book text.
        bookText.attributedText = myText
    }
    
    
    /********** NEXT BUTTONS FUNCTIONS **********/
    // When the user clicks the againButton, go back to the color options
    @IBAction func againButton(_ sender: Any) {
        // Hide the next buttons
        nextButtons.isHidden = true
        
        // Show the color options
        pickColor.isHidden = false
        goButton.isHidden = false
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the Question scene.
    @IBAction func backButton(_ sender: Any) {
        // Stop timer
        scrollTimer.invalidate()
        scrollTimer = nil
        invalidated = true
        
        // Go to the Question scene.
        self.performSegue(withIdentifier: "QuestionBack", sender: self)
    }
    
    // When user clicks the go button, it sends them to the ... scene
    @IBAction func doneButton(_ sender: Any) {
        // Update modelController
        modelController.currentRanges.append(answerRanges)
        modelController.currentAttributes.append(newAttributes)
        
        // Update the question and go to the correct scene
        let mySections:[BookSection] = modelController.myBook.sections
        let myQuestions:[String] = mySections[modelController.mySection].questions
        if myQuestions.count > modelController.myQuestion + 1 {
            // There are still questions left. Go to next question.
            modelController.myQuestion += 1
            
            // Stop timer
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to Question scene.
            self.performSegue(withIdentifier: "Question", sender: self)
        } else if mySections.count > modelController.mySection + 1 {
            // There are no questions left in the section, but there are more sections left.
            // Save and reset currentRanges and currentAttributes.
            modelController.allRanges.append(modelController.currentRanges)
            modelController.allAttributes.append(modelController.currentAttributes)
            modelController.currentRanges = []
            modelController.currentAttributes = []
            
            // Add section text to allText.
            let separator:NSAttributedString = NSAttributedString(string: mySeparator)
            myText.append(separator)
            modelController.allText.append(myText)
            
            // Go to next section.
            modelController.mySection += 1
            modelController.myQuestion = 0
            
            // Stop timer
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to Question scene.
            self.performSegue(withIdentifier: "Question", sender: self)
        } else {
            // There are no questions left in the section, and there are no sections left in the book.
            // Save and reset currentRanges and currentAttributes.
            modelController.allRanges.append(modelController.currentRanges)
            modelController.allAttributes.append(modelController.currentAttributes)
            modelController.currentRanges = []
            modelController.currentAttributes = []
            
            // Add section text and separator to allText.
            let separator:NSAttributedString = NSAttributedString(string: mySeparator)
            myText.append(separator)
            modelController.allText.append(myText)
            
            // Stop timer
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to ReadingInstructions.
            self.performSegue(withIdentifier: "ReadingInstructions", sender: self)
        }
    }
    
    // Pass shared data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //UserDefaults.standard.set(modelController, forKey: "modelController")
        
        // Update the modelController in the Question scene.
        if segue.destination is QuestionViewController {
            let Destination = segue.destination as? QuestionViewController
            Destination?.modelController = modelController
        }

        // Update the modelController in the ReadingInstructions scene.
        if segue.destination is ReadingInstructionsViewController {
            let Destination = segue.destination as? ReadingInstructionsViewController
            Destination?.modelController = modelController
        }
    }
}
