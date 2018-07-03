//
//  QuestionViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/19/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITextViewDelegate {
    /********** LOCAL VARIABLES **********/
    // Color changing objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var clearButton: UIView!
    @IBOutlet weak var goButton: UIView!
    
    // Label
    @IBOutlet weak var bookTitle: UILabel!
    
    // Book info
    @IBOutlet weak var bookText: UITextView!
    @IBOutlet weak var bookQuestion: UITextView!
    
    // Current text, question, and answer
    var myText: NSMutableAttributedString = NSMutableAttributedString(string: "")
    var myQuestion: String = ""
    var myAnswers: [String] = []
    var mySeparator: String = ""
    var wordRanges: [NSRange] = []
    var answerRanges: [NSRange] = []
    var correctAnswers: [Bool] = []
    var attemptedAnswers: [Bool] = []
    var failedAttempt: Bool = false
    
    // Scrollbar timer
    var scrollTimer: Timer!
    var invalidated: Bool = false
    
    // Reference to data
    var modelController:ModelController = ModelController()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
        bookTitle.text = modelController.myBook.file
        bookText.delegate = self
        bookText.isSelectable = true
        bookText.isEditable = false
        
        // Update the text, question, and answers when moving to a new question.
        updateQuestion()
        
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
    
    func updateColors() {
        background.backgroundColor = modelController.getColorBackground(color: modelController.myColor, opacity: 1.0)
        header.backgroundColor = modelController.getColorLight(color: modelController.myColor, opacity: 0.8)
        goButton.backgroundColor = modelController.getColorRegular(color: modelController.myColor, opacity: 1.0)
        clearButton.backgroundColor = modelController.getColorRegular(color: modelController.myColor, opacity: 1.0)
    }
    
    /*
     Accesses the correct section, text, questions, and answers.
     Makes each word in the text its own url link, with the url function disabled.
     Check if there has been a failed attempt.
     Update bookText and bookQuestion.
    */
    func updateQuestion() {
        // Access the correct text, question, and answers.
        let mySection:BookSection = modelController.myBook.sections[modelController.mySection]
        myText = mySection.text
        myQuestion = mySection.questions[modelController.myQuestion]
        myAnswers = mySection.answers[modelController.myQuestion]
        mySeparator = mySection.separator
        wordRanges = []
        correctAnswers = []
        attemptedAnswers = []
        
        // Makes each word in the text its own url link, with the url function disabled.
        var textCopy:String = myText.string
        var textBeforeCopy:Int = 0
        while !textCopy.isEmpty {
            // Find the first word.
            let space:String = " "
            if textCopy.contains(space) {
                // There are multiple words.
                // The default values of the first word separator are those of the first space.
                var firstRangeCopy:Range<String.Index> = textCopy.range(of: space)!
                var firstEnd:Int = firstRangeCopy.upperBound.encodedOffset
                
                // Check if the words are spread out over multiple lines.
                let newLine:String = "\n"
                if textCopy.contains(newLine) {
                    // Find range of the first new line in textCopy.
                    let lineRangeCopy:Range<String.Index> = textCopy.range(of: newLine)!
                    let lineEnd:Int = lineRangeCopy.upperBound.encodedOffset
                    
                    // Check if the first new line occurs before the first space.
                    if lineEnd < firstEnd {
                        firstRangeCopy = lineRangeCopy
                        firstEnd = lineEnd
                    }
                }
                
                // Make the first word a link in myText.
                let wordLength:Int = firstRangeCopy.lowerBound.encodedOffset
                let rangeOriginal:NSRange = NSMakeRange(textBeforeCopy, wordLength)
                myText.addAttribute(.link, value: "word", range: rangeOriginal)
                
                // Check if the word is an answer.
                let word:String = String(textCopy.prefix(upTo: firstRangeCopy.lowerBound))
                var isAnswer:Bool = false
                for answer in myAnswers {
                    let answerVariations:[String] = [answer, answer + ".", answer + ",", answer + "?", answer + "!", answer + "\"", answer + ".\"", answer + ",\"", answer + "?\"", answer + "!\""]
                    if answerVariations.contains(word) {
                        isAnswer = true
                    }
                }
                
                // Update correctAnswers, attemptedAnswers, wordRanges, and answerRanges.
                correctAnswers.append(isAnswer)
                attemptedAnswers.append(false)
                wordRanges.append(rangeOriginal)
                if isAnswer {
                    answerRanges.append(rangeOriginal)
                }
                
                // Remove this word from textCopy.
                textCopy.removeSubrange(textCopy.startIndex..<firstRangeCopy.upperBound)
                textBeforeCopy += firstEnd
                
            } else {
                // There is only one word.
                // Make the word a link in myText.
                let wordLength:Int = textCopy.count
                let rangeOriginal:NSRange = NSMakeRange(textBeforeCopy, wordLength)
                myText.addAttribute(.link, value: "word", range: rangeOriginal)
                
                // Check if the word is an answer.
                let word:String = textCopy
                var isAnswer:Bool = false
                for answer in myAnswers {
                    let answerVariations:[String] = [answer, answer + ".", answer + ",", answer + "?", answer + "!", answer + "\"", answer + ".\"", answer + ",\"", answer + "?\"", answer + "!\""]
                    if answerVariations.contains(word) {
                        isAnswer = true
                    }
                }
                
                // Update correctAnswers, attemptedAnswers, wordRanges, and answerRanges.
                correctAnswers.append(isAnswer)
                attemptedAnswers.append(false)
                wordRanges.append(rangeOriginal)
                if isAnswer {
                    answerRanges.append(rangeOriginal)
                }
                
                // Since there was only one word, there is nothing left in textCopy.
                textCopy = ""
            }
        }
        
        // Check if there has been a failed attempt.
        var questionText = myQuestion
        if failedAttempt {
            questionText = "Try again!\n" + myQuestion
        }
        
        // Reset attributes to standard
        let myRange:NSRange = NSMakeRange(0, myText.length)
        myText.removeAttribute(.backgroundColor, range: myRange)
        myText.removeAttribute(.shadow, range: myRange)
        myText.removeAttribute(.underlineStyle, range: myRange)
        myText.addAttributes(modelController.standardAttributes, range: myRange)
        
        // Update bookText and bookQuestion.
        bookText.attributedText = myText
        bookText.tintColor = UIColor.black
        bookQuestion.text = questionText
    }
    
    @objc func flashIndicator() {
        if !invalidated {
            bookText.flashScrollIndicators()
        }
    }
    
    
    /********** INTERACTIVE FUNCTIONS **********/
    // When the user taps on a word, it becomes unselectable and changes colors. Disables the url link.
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // Make word unselectable and change its color
        myText.removeAttribute(.link, range: characterRange)
        myText.addAttribute(.foregroundColor, value: modelController.getColorRegular(color: modelController.myColor, opacity: 1.0), range: characterRange)
        bookText.attributedText = myText

        // Find characterRange location in wordRanges
        var location:Int = 0
        for range in wordRanges {
            if range == characterRange {
                break
            }
            location += 1
        }
        
        // Update attemptedAnswers
        attemptedAnswers[location] = true
        
        // Don't go to url
        return false
    }
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the StudentBooks scene.
    @IBAction func backButton(_ sender: Any) {        
        if modelController.myQuestion != 0 {
            // This is not the first question.
            modelController.myQuestion -= 1

            // Get previous separator and answer ranges
            mySeparator = modelController.myBook.sections[modelController.mySection].separator
            answerRanges = modelController.currentRanges.last!
            
            // Stop timer
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to Graphics scene.
            self.performSegue(withIdentifier: "GraphicsBack", sender: self)
        } else if modelController.mySection != 0 {
            // This is the first question, but not the first section.
            modelController.mySection -= 1
            modelController.myQuestion = modelController.myBook.sections[modelController.mySection].questions.count - 1
            
            // Get previous text
            myText = modelController.allText.removeLast()
            
            // Get previous ranges and attributes
            modelController.currentRanges = modelController.allRanges.removeLast()
            modelController.currentAttributes = modelController.allAttributes.removeLast()
            
            // Get previous separator and answer ranges
            mySeparator = modelController.myBook.sections[modelController.mySection].separator
            answerRanges = modelController.currentRanges.last!
            
            // Stop timer
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to Graphics scene.
            self.performSegue(withIdentifier: "GraphicsBack", sender: self)
        } else {
            // This is the first section and the first question.
            modelController.mySection = 0
            modelController.myQuestion = 0
            
            // Reset values
            modelController.currentRanges = []
            modelController.currentAttributes = []
            modelController.allText = []
            modelController.allRanges = []
            modelController.allAttributes = []
            
            // Stop timer
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to StudentBooks.
            self.performSegue(withIdentifier: "StudentBooks", sender: self)
        }
    }
    
    // When user clicks the audio button, it plays the audio
    @IBAction func audioButton(_ sender: Any) {
        // Play audio
        print("Play Question audio")
    }
    
    // When the user clicks the refresh button, it resets the links and colors
    @IBAction func clearButton(_ sender: Any) {
        
        updateQuestion()
    }
    
    // When user clicks the go button, it sends them to the ... scene
    @IBAction func goButton(_ sender: Any) {
        // check if answer is correct
        if correctAnswers == attemptedAnswers {
            failedAttempt = false
            
            // Stop timer
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to Graphics scene.
            self.performSegue(withIdentifier: "Graphics", sender: self)
        } else {
            failedAttempt = true

            // Try again.
            updateQuestion()
        }
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in the StudentBooks scene.
        if segue.destination is StudentBooksViewController {
            // Update the modelController.
            let Destination = segue.destination as? StudentBooksViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelController, myText, and answerRanges in the Graphics scene.
        if segue.destination is GraphicsViewController {
            let Destination = segue.destination as? GraphicsViewController
            Destination?.modelController = modelController
            Destination?.myText = myText
            Destination?.answerRanges = answerRanges
            Destination?.mySeparator = mySeparator
        }
    }
}
