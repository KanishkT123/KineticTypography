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
    
    // Header
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
    
    var data:Data = Data()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set delegates.
        bookText.delegate = self
        bookText.isSelectable = true
        bookText.isEditable = false
        
        // Update the color scheme.
        updateColors()
        
        // Set header.
        bookTitle.text = data.myBook.file
        bookTitle.baselineAdjustment = .alignCenters
        
        // Update the text, question, and answers when moving to a new question.
        updateQuestion()
        
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
        
        // Start at top of text
        bookText.scrollsToTop = true
    }
    
    func updateColors() {
        let colorScheme:Color = data.colors[data.myColor]
        background.backgroundColor = colorScheme.getColorBackground(opacity: 1.0)
        header.backgroundColor = colorScheme.getColorLight(opacity: 0.8)
        goButton.backgroundColor = colorScheme.getColorRegular(opacity: 1.0)
        clearButton.backgroundColor = colorScheme.getColorRegular(opacity: 1.0)
    }
    
    /*
     Accesses the correct section, text, questions, and answers.
     Makes each word in the text its own url link, with the url function disabled.
     Check if there has been a failed attempt.
     Update bookText and bookQuestion.
    */
    func updateQuestion() {
        // Access the correct text, question, and answers.
        let mySection:BookSection = data.myBook.sections[data.mySectionNum]
        myText = mySection.text
        myQuestion = mySection.questions[data.myQuestionNum]
        myAnswers = mySection.answers[data.myQuestionNum]
        mySeparator = mySection.separator
        wordRanges = []
        correctAnswers = []
        attemptedAnswers = []
        
        // Makes each word in the text its own url link, with the url function disabled.
        var textCopy:String = myText.string
        var textBeforeCopy:Int = 0
        while !textCopy.isEmpty {
            // Find the next word.
            let space:String = " "
            if textCopy.contains(space) {
                // For this case, there are multiple words.
                
                // The default values of the next word separator are those of the first space.
                var nextRangeCopy:Range<String.Index> = textCopy.range(of: space)!
                var nextEnd:Int = nextRangeCopy.upperBound.encodedOffset
                
                // Check if the words are spread out over multiple lines.
                let newLine:String = "\n"
                if textCopy.contains(newLine) {
                    // Find range of the first new line in textCopy.
                    let lineRangeCopy:Range<String.Index> = textCopy.range(of: newLine)!
                    let lineEnd:Int = lineRangeCopy.upperBound.encodedOffset
                    
                    // Check if the first new line occurs before the first space.
                    if lineEnd < nextEnd {
                        nextRangeCopy = lineRangeCopy
                        nextEnd = lineEnd
                    }
                }
                
                // Make the next word a link in myText.
                let wordLength:Int = nextRangeCopy.lowerBound.encodedOffset
                let rangeOriginal:NSRange = NSMakeRange(textBeforeCopy, wordLength)
                myText.addAttribute(.link, value: "word", range: rangeOriginal)
                
                // Check if the word is an answer.
                let word:String = String(textCopy.prefix(upTo: nextRangeCopy.lowerBound))
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
                textCopy.removeSubrange(textCopy.startIndex..<nextRangeCopy.upperBound)
                textBeforeCopy += nextEnd
                
            } else {
                // For this case, there is only one word.
                
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
        let standardAttributes = data.standardAttributes
        myText.removeAttribute(.backgroundColor, range: myRange)
        myText.removeAttribute(.shadow, range: myRange)
        myText.removeAttribute(.underlineStyle, range: myRange)
        myText.addAttributes(standardAttributes, range: myRange)
        
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
        let colorScheme:Color = data.colors[data.myColor]
        myText.removeAttribute(.link, range: characterRange)
        myText.addAttribute(.foregroundColor, value: colorScheme.getColorRegular(opacity: 1.0), range: characterRange)
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
        if data.myQuestionNum != 0 {
            // This is not the first question.
            data.myQuestionNum -= 1

            // Get previous separator and answer ranges
            mySeparator = data.myBook.sections[data.mySectionNum].separator
            answerRanges = data.currentRanges.last!
            
            // Stop timer
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to Graphics scene.
            self.performSegue(withIdentifier: "GraphicsBack", sender: self)
        } else if data.mySectionNum != 0 {
            // This is the first question, but not the first section.
            data.mySectionNum -= 1
            data.myQuestionNum = data.myBook.sections[data.mySectionNum].questions.count - 1
            
            // Get previous text
            myText = data.allText.removeLast()
            
            // Get previous ranges and attributes
            data.currentRanges = data.allRanges.removeLast()
            data.currentAttributes = data.allAttributes.removeLast()
            
            // Get previous separator and answer ranges
            mySeparator = data.myBook.sections[data.mySectionNum].separator
            answerRanges = data.currentRanges.last!
            
            // Stop timer
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to Graphics scene.
            self.performSegue(withIdentifier: "GraphicsBack", sender: self)
        } else {
            // This is the first section and the first question.
            data.mySectionNum = 0
            data.myQuestionNum = 0
            
            // Reset values
            data.currentRanges = []
            data.currentAttributes = []
            data.allText = []
            data.allRanges = []
            data.allAttributes = []
            
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
    
    // When user clicks the go button, it sends them to the Graphics scene.
    @IBAction func goButton(_ sender: Any) {
        // check if answer is correct
        if correctAnswers == attemptedAnswers {
            // For this case, the user's answers are correct.
            
            // Update failedAttempt to record that the attempted answers are correct.
            failedAttempt = false
            
            // Stop the scrollTimer.
            scrollTimer.invalidate()
            scrollTimer = nil
            invalidated = true
            
            // Go to the Graphics scene.
            self.performSegue(withIdentifier: "Graphics", sender: self)
        } else {
            // For this case, the user's answers are not correct.
            
            // Update failedAttempt to record that the attempted answers are not correct.
            failedAttempt = true

            // Clear the attempted answers.
            updateQuestion()
        }
    }
    
    // Pass saved data at segues.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the StudentBooks scene.
        if segue.destination is StudentBooksViewController {
            let Destination = segue.destination as? StudentBooksViewController
            Destination?.data = data
        }

        // Update the data, myText, and answerRanges in the Graphics scene.
        if segue.destination is GraphicsViewController {
            let Destination = segue.destination as? GraphicsViewController
            Destination?.data = data
            Destination?.myText = myText
            Destination?.answerRanges = answerRanges
            Destination?.mySeparator = mySeparator
        }
    }
}
