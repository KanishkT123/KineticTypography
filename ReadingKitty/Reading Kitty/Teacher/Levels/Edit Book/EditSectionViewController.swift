//
//  EditSectionViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/27/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class EditSectionViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AnswersTableViewCellDelegate, QuestionsTableViewCellDelegate {
    /********** LOCAL VARIABLES **********/
    // Header
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookSection: UILabel!

    // Book data
    var currentQuestions:[String] = []
    var currentDevices:[String] = []
    var currentAnswers:[[String]] = []

    // Text
    @IBOutlet weak var textBox: UITextView!
    
    // Separators
    @IBOutlet weak var newLineBackground: UIView!
    @IBOutlet weak var spaceBackground: UIView!
    @IBOutlet weak var noneBackground: UIView!
    @IBOutlet weak var newLineLabel: UILabel!
    @IBOutlet weak var spaceLabel: UILabel!
    @IBOutlet weak var noneLabel: UILabel!
    @IBOutlet weak var newLineExample: UILabel!
    @IBOutlet weak var spaceExample: UILabel!
    @IBOutlet weak var noneExample: UILabel!
    var separatorSelected:String = ""

    // New Question
    @IBOutlet weak var newQuestion: UITextField!
    @IBOutlet weak var dropStack: UIStackView!
    @IBOutlet weak var deviceDrop: UIButton!
    var deviceButtons: [UIButton] = []
    @IBOutlet weak var newAnswer: UITextField!
    var newAnswers: [String] = []
    @IBOutlet weak var answersTable: UITableView!
    
    // All Questions
    @IBOutlet weak var questionsTable: UITableView!
    
    // Error messages
    @IBOutlet weak var oopsErrors: UILabel!
    @IBOutlet weak var questionQuestionError: UILabel!
    @IBOutlet weak var questionDeviceError: UILabel!
    @IBOutlet weak var questionAnswerError: UILabel!
    @IBOutlet weak var sectionTextError: UILabel!
    @IBOutlet weak var sectionSeparatorError: UILabel!
    @IBOutlet weak var sectionQuestionError: UILabel!
    @IBOutlet weak var answerError: UILabel!
    
    // Parsing variables.
//    var xmlText:String = ""
//    var tempText:String = ""
//    var parsingSection:Int = 0
    var updatingSection:Bool = true
    
    // UserDefaults variables.
    var parser:myParser = myParser()
    var data:Data = Data()
    var library:Library = Library()
    
    
    /********** VIEW FUNCTIONS **********/
    /*
     This function sets the delegates and header, and ranks the levels.
     It is called when the view controller is about to appear.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values.
        parser.data = data
        library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
        
        // Set delegates.
        textBox.delegate = self
        newQuestion.delegate = self
        newAnswer.delegate = self
        answersTable.delegate = self
        answersTable.dataSource = self
        questionsTable.delegate = self
        questionsTable.dataSource = self
        
        // Set header.
        bookTitle.text = data.myBook.file
        bookTitle.baselineAdjustment = .alignCenters
        bookSection.text = "Section \(data.mySectionNum + 1)"
        
        // Set the separators' backgrounds.
        resetSeparators()
        
        // Set the separators' example text.
        setSeparatorExamples()
        
        // Add all devices to deviceButtons
        setDevices()
        
        // Hide errors.
        hideErrors()
        
        // Update scene to match current section data.
        updateScene()
    }
    
    /*
     This function hides all of the error messages.
     */
    func hideErrors() {
        oopsErrors.isHidden = true
        questionQuestionError.isHidden = true
        questionDeviceError.isHidden = true
        questionAnswerError.isHidden = true
        sectionTextError.isHidden = true
        sectionSeparatorError.isHidden = true
        sectionQuestionError.isHidden = true
        answerError.isHidden = true
    }
    
    /*
     This function sets the separators' example text.
     */
    func setSeparatorExamples() {
        // partOne represents the current section's text.
        let partOne:NSAttributedString = NSAttributedString(string: "This represents the text from this section.", attributes: [NSAttributedStringKey.foregroundColor: UIColor.purple, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
        
        // partTwo represents the next section's text.
        let partTwo:NSMutableAttributedString = NSMutableAttributedString(string: "This represents the text from the next section.", attributes: [NSAttributedStringKey.foregroundColor: UIColor.brown, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
        
        // Add text to the new line example.
        var combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(NSAttributedString(string: "\n"))
        combination.append(partTwo)
        newLineExample.attributedText = combination
        
        // Add text to the space example.
        combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(NSAttributedString(string: " "))
        combination.append(partTwo)
        spaceExample.attributedText = combination
        
        // Add text to the none example.
        combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(NSAttributedString(string: ""))
        combination.append(partTwo)
        noneExample.attributedText = combination
    }
    
    /*
     This function creates a button for each device.
     */
    func setDevices() {
        // Clear previous buttons.
        while deviceButtons.isNotEmpty {
            let button:UIButton = deviceButtons.removeFirst()
            dropStack.removeArrangedSubview(button)
        }
        
        // Get all devices with no repetitions.
        var devices:[String] = []
        for level:[String] in data.allDevices {
            for device:String in level {
                if !devices.contains(device) {
                    devices.append(device)
                }
            }
        }
        
        // Create a button for each device.
        for device:String in devices {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 90))
            button.backgroundColor = data.colors[4].getColorRegular(opacity: 1)
            button.isHidden = true
            button.setTitle(device, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = button.titleLabel?.font.withSize(30.0)
            button.addTarget(self, action: #selector(deviceTapped(_:)), for: .touchUpInside)
            dropStack.addArrangedSubview(button)
            deviceButtons.append(button)
        }
    }
    
    func updateScene() {
        // Get section
        let section:BookSection = data.myBook.sections[data.mySectionNum]
        
        // Update text
        textBox.text = section.text.string
        
        // Update separator
        resetSeparators()
        if section.separator == "New Line" {
            // Make new line background visible.
            let blue:Color = data.colors[4]
            newLineBackground.backgroundColor = blue.getColorLight(opacity: 0.6)
            newLineLabel.textColor = blue.getColorDark(opacity: 1)
            separatorSelected = "New Line"
        } else if section.separator == "Space" {
            // Make space background visible.
            let blue:Color = data.colors[4]
            spaceBackground.backgroundColor = blue.getColorLight(opacity: 0.6)
            spaceLabel.textColor = blue.getColorDark(opacity: 1)
            separatorSelected = "Space"
        } else {
            // Make none background visible.
            let blue:Color = data.colors[4]
            noneBackground.backgroundColor = blue.getColorLight(opacity: 0.6)
            noneLabel.textColor = blue.getColorDark(opacity: 1)
            separatorSelected = "None"
        }
        
        // Update all questions
        currentQuestions = section.questions
        currentDevices = section.devices
        currentAnswers = section.answers
        questionsTable.reloadData()
        
        // Clear new question
        newQuestion.text = ""
        deviceDrop.setTitle("Select a Literary Device", for: .normal)
        newAnswer.text = ""
    }
    
    
    /********** TEXT FUNCTIONS **********/
    /*
     This function makes the new line separator appear selected. It is called when the user taps the new line button.
     */
    @IBAction func newLineButton(_ sender: Any) {
        // Make all backgrounds invisible.
        resetSeparators()
        
        // Make new line background visible.
        let blue:Color = data.colors[4]
        newLineBackground.backgroundColor = blue.getColorLight(opacity: 0.6)
        newLineLabel.textColor = blue.getColorDark(opacity: 1)
        separatorSelected = "New Line"
    }
    
    /*
     This function makes the space separator appear selected. It is called when the user taps the space button.
     */
    @IBAction func spaceButton(_ sender: Any) {
        // Make all backgrounds invisible.
        resetSeparators()
        
        // Make space background visible.
        let blue:Color = data.colors[4]
        spaceBackground.backgroundColor = blue.getColorLight(opacity: 0.6)
        spaceLabel.textColor = blue.getColorDark(opacity: 1)
        separatorSelected = "Space"
    }
    
    /*
     This function makes the none separator appear selected. It is called when the user taps the none button.
     */
    @IBAction func noneButton(_ sender: Any) {
        // Make all backgrounds invisible.
        resetSeparators()
        
        // Make none background visible.
        let blue:Color = data.colors[4]
        noneBackground.backgroundColor = blue.getColorLight(opacity: 0.6)
        noneLabel.textColor = blue.getColorDark(opacity: 1)
        separatorSelected = "None"
    }
    
    /*
     This function makes all of the separators appear unseleted.
     */
    func resetSeparators() {
        newLineBackground.backgroundColor = UIColor.clear
        spaceBackground.backgroundColor = UIColor.clear
        noneBackground.backgroundColor = UIColor.clear
        let blue:Color = data.colors[4]
        newLineLabel.textColor = blue.getColorLight(opacity: 1)
        spaceLabel.textColor = blue.getColorLight(opacity: 1)
        noneLabel.textColor = blue.getColorLight(opacity: 1)
        separatorSelected = ""
    }
    
    
    /********** NEW QUESTION FUNCTIONS **********/
    /*
     This function makes the text field go inactive. It is called when the user taps return on the keyboard.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    /*
     This function makes the drop-down menu visible. It is called when the user taps on the devices button.
     */
    @IBAction func deviceDrop(_ sender: Any) {
        // Change the visibility of the buttons (visible to unvisible or vise versa).
        deviceButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /*
     This function sets the selected device. It is called when the user taps on a devices.
     */
    @IBAction func deviceTapped(_ sender: UIButton) {
        // Update the selected device.
        deviceDrop.setTitle(sender.currentTitle, for: .normal)
        
        // Hide buttons
        deviceButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /*
     This function saves the new answer and updates the answers table. It is called when the user taps the add answer button.
     */
    @IBAction func addAnswer(_ sender: Any) {
        // Hide errors.
        hideErrors()
        
        // Check if new answer exists in the section's text.
        if checkAnswer() {
            // For this case, the new answer exists in the section's text.
            
            // Save the answer.
            newAnswers.append(newAnswer.text!)
            
            // Clear the answer textBox
            newAnswer.text = ""
            
            // Update the answers table.
            answersTable.reloadData()
        } else {
            // For this case, the new answer does not exist in the section's text.
            
            // Show corresponding errors.
            oopsErrors.isHidden = false
            answerError.isHidden = false
        }
    }
    
    /*
     This function checks if the answer exists in the section's text. It returns true if the answer exists and false if the answer does not exist.
     */
    func checkAnswer() -> Bool {
        let answer:String = newAnswer.text!
        let answerVariations:[String] = [answer, answer + ".", answer + ",", answer + "?", answer + "!", answer + "\"", answer + ".\"", answer + ",\"", answer + "?\"", answer + "!\""]
        var textCopy:String = textBox.text
        var textBeforeCopy:Int = 0
        var isAnswer:Bool = false
        
        // Check each word
        while !textCopy.isEmpty && !isAnswer {
            let space:String = " "
            let newLine:String = "\n"
            if textCopy.contains(space) {
                // For this case, there are multiple words remaining.
                
                // This first word is either separated from the next word by a space or a new line. Assume that the first word is separated by a space.
                var wordSeparator:Range<String.Index> = textCopy.range(of: space)!
                
                // The first word ends at the beginning of the first space.
                var firstWordEnd:Int = wordSeparator.upperBound.encodedOffset
                
                // Check if there are multiple lines.
                if textCopy.contains(newLine) {
                    // For this case, there are multiple lines.
                    
                    // The varaiable lineEnd stores the beginning of the first new line.
                    let lineRangeCopy:Range<String.Index> = textCopy.range(of: newLine)!
                    let lineEnd:Int = lineRangeCopy.upperBound.encodedOffset
                    
                    // Check if the first new line occurs before the first space.
                    if lineEnd < firstWordEnd {
                        // For this case, the new line occurs before the space. This means that the first word is separated by a new line, not a space.
                        wordSeparator = lineRangeCopy
                        firstWordEnd = lineEnd
                    }
                }
                
                // Check if the first word is the attempted answer.
                let word:String = String(textCopy.prefix(upTo: wordSeparator.lowerBound))
                if answerVariations.contains(word) {
                    isAnswer = true
                }
                
                // Remove this word from textCopy.
                textCopy.removeSubrange(textCopy.startIndex..<wordSeparator.upperBound)
                textBeforeCopy += firstWordEnd
            } else if textCopy.contains(newLine){
                // For this case, there are multiple lines, but no spaces. This means that there is only one word per line.
                
                // This first word is separated from the next word by a new line.
                let wordSeparator:Range<String.Index> = textCopy.range(of: newLine)!
                
                // The first word ends at the beginning of the first new line.
                let firstWordEnd:Int = wordSeparator.upperBound.encodedOffset
                
                // Check if the first word is the attempted answer.
                let word:String = String(textCopy.prefix(upTo: wordSeparator.lowerBound))
                if answerVariations.contains(word) {
                    isAnswer = true
                }
                
                // Remove this word from textCopy.
                textCopy.removeSubrange(textCopy.startIndex..<wordSeparator.upperBound)
                textBeforeCopy += firstWordEnd
            } else {
                // For this case, there is only one word.
                
                // Check if the word is the attempted answer.
                let word:String = textCopy
                if answerVariations.contains(word) {
                    isAnswer = true
                }
                
                // Since there was only one word, there is nothing left in textCopy.
                textCopy = ""
            }
        }
        
        return isAnswer
    }
    
    /*
     This function saves the question, device, and answers, and updates the questionsTable. It is called when the user taps the add question button.
     */
    @IBAction func addQuestion(_ sender: Any) {
        // Hide errors.
        hideErrors()
        
        // Check if new question has all of the pieces.
        if newQuestion.text != "" && deviceDrop.currentTitle != "Select a Literary Device" && newAnswers != [] {
            // For this case, the new question has all of its pieces.
            
            // Save the question details.
            currentQuestions.append(newQuestion.text!)
            currentDevices.append(deviceDrop.currentTitle!)
            currentAnswers.append(newAnswers)
            
            // Clear the question details.
            newQuestion.text = ""
            deviceDrop.setTitle("Select a Literary Device", for: .normal)
            newAnswers = []
            answersTable.reloadData()
            
            // Update the questions table.
            questionsTable.reloadData()
        } else {
            // For this case, the new question does not have all of its pieces.
            
            oopsErrors.isHidden = false
            if newQuestion.text == "" {
                questionQuestionError.isHidden = false
            }
            if deviceDrop.currentTitle == "Select a Literary Device" {
                questionDeviceError.isHidden = false
            }
            if newAnswers == [] {
                questionAnswerError.isHidden = false
            }
        }
    }
    
    
    /********** ALL QUESTIONS FUNCTIONS **********/
    /*
     This function sets the number of rows to the number of questions.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == answersTable {
            return newAnswers.count
        } else {
            return currentQuestions.count
        }
    }
    
    /*
     This function configures each cell by row.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == answersTable {
            // For this case, the table is the answersTable.
            
            // Access the current row.
            let Cell:AnswersTableViewCell = answersTable.dequeueReusableCell(withIdentifier: "Answer", for: indexPath) as! AnswersTableViewCell
            Cell.delegate = self
            
            // Create answer label.
            Cell.answer.frame = CGRect(x: 10, y: 0, width: 850, height: 60)
            Cell.answer.backgroundColor = UIColor.clear
            Cell.answer.text = newAnswers[indexPath.row]
            Cell.answer.textColor = textBox.backgroundColor
            Cell.answer.font = Cell.answer.font.withSize(30.0)
            
            // Create delete button.
            Cell.deleteButton.frame = CGRect(x: 850, y: 0, width: 80, height: 60)
            Cell.deleteButton.backgroundColor = UIColor.clear
            Cell.deleteButton.setTitle("Delete", for: .normal)
            Cell.deleteButton.setTitleColor(UIColor.black, for: .normal)
            
            return Cell
        } else {
            // For this case, the table is the questionsTable.
            
            // Access the current row.
            let Cell:QuestionsTableViewCell = questionsTable.dequeueReusableCell(withIdentifier: "Question", for: indexPath) as! QuestionsTableViewCell
            Cell.delegate = self
            
            // Create question label.
            Cell.question.frame = CGRect(x: 10, y: 0, width: 850, height: 45)
            Cell.question.backgroundColor = UIColor.clear
            Cell.question.text = currentQuestions[indexPath.row]
            Cell.question.textColor = textBox.backgroundColor
            Cell.question.font = Cell.device.font.withSize(30.0)
            
            // Create device label.
            Cell.device.frame = CGRect(x: 50, y: 45, width: 850, height: 25)
            Cell.device.backgroundColor = UIColor.clear
            Cell.device.text = currentDevices[indexPath.row]
            Cell.device.textColor = textBox.backgroundColor
            Cell.device.font = Cell.device.font.withSize(20.0)
            
            // Create answers label.
            Cell.answers.frame = CGRect(x: 50, y: 70, width: 850, height: 25)
            Cell.answers.backgroundColor = UIColor.clear
            Cell.answers.textColor = textBox.backgroundColor
            Cell.answers.font = Cell.answers.font.withSize(20.0)
            Cell.answers.text = ""
            for answer:String in currentAnswers[indexPath.row] {
                Cell.answers.text?.append(answer + ", ")
            }
            // Remove last comma and space.
            Cell.answers.text?.removeLast()
            Cell.answers.text?.removeLast()
            
            // Create delete button.
            Cell.deleteButton.frame = CGRect(x: 850, y: 0, width: 80, height: 100)
            Cell.deleteButton.backgroundColor = UIColor.clear
            Cell.deleteButton.setTitle("Delete", for: .normal)
            Cell.deleteButton.setTitleColor(UIColor.black, for: .normal)
            
            return Cell
        }
        
    }
    
    /*
     This function deletes the answer and reloads the table. It gets called when the user taps on the delete answer button.
     */
    func deleteButtonTapped(_ sender: AnswersTableViewCell) {
        // Get the question's index.
        guard let tappedIndexPath = answersTable.indexPath(for: sender) else { return }
        
        // Delete the answer.
        newAnswers.remove(at: tappedIndexPath.row)
        
        // Update the answers table.
        answersTable.reloadData()
    }
    
    /*
     This function deletes the question and reloads the table. It gets called when the user taps on the delete question button.
     */
    func deleteButtonTapped(_ sender: QuestionsTableViewCell) {
        // Get the question's index.
        guard let tappedIndexPath = questionsTable.indexPath(for: sender) else { return }
        
        // Delete the question.
        currentQuestions.remove(at: tappedIndexPath.row)
        currentDevices.remove(at: tappedIndexPath.row)
        currentAnswers.remove(at: tappedIndexPath.row)
        
        // Update the questions tables.
        questionsTable.reloadData()
    }
    
    
    /********** PARSING FUNCTIONS **********/
//    /*
//     This function parses the book.
//    */
//    func startParse() {
//        // Access the book file.
//        let fileName = data.myBook.file
//        let url:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName + ".xml"))!
//
//        // Parse the book.
//        let parser: XMLParser = XMLParser(contentsOf: url)!
//        parser.delegate = self
//        parser.parse()
//    }
    
//    /*
//     This function either adds the start tag or updates the section. It is called when the parser reads a start tag.
//    */
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        if parsingSection == data.mySectionNum {
//            // This is the updated section. Delete the old section by not adding it to xmlText, and add the updated section.
//            if elementName == "section" {
//                newSection()
//            }
//
//        } else {
//            // This is not the updated section. Keep the current section.
//            xmlText.append("<\(elementName)")
//        }
//    }
//
//    /*
//     This function saves the characters into tempText. It is called when the parser reads a character.
//    */
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        tempText.append(string)
//    }

//    /*
//     This function ... It is called every time the parser reads an end tag.
//    */
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        if parsingSection == data.mySectionNum {
//            // This is the updated section. Delete the old section by not adding it to xmlText.
//        } else {
//            // This is not the updated section. Keep the current section.
//            xmlText.append(tempText)
//            xmlText.append("</\(elementName)")
//        }
//
//        if elementName == "section" {
//            // This is the end of a section, so the next section will now be parsed.
//            parsingSection += 1
//        }
//
//        // Reset the text.
//        tempText = ""
//    }
//
//    /*
//     This function ...
//    */
//    func newSection() {
//        // Start the section
//        xmlText.append("<section>")
//
//        // Add the text
//        xmlText.append("<text>")
//        xmlText.append(textBox.text)
//        xmlText.append("</text>")
//
//        // Add the separator
//        xmlText.append("<separator>")
//        xmlText.append(separatorSelected)
//        xmlText.append("</separator>")
//
//        // Add each question, device, and answers
//        for questionInt:Int in 0..<currentQuestions.count {
//            // Add the question
//            xmlText.append("<question>")
//            xmlText.append(currentQuestions[questionInt])
//            xmlText.append("</question>")
//
//            // Add the device
//            xmlText.append("<device>")
//            xmlText.append(currentDevices[questionInt])
//            xmlText.append("</device>")
//
//            // Add the answers
//            print(currentAnswers)
//            xmlText.append("<answer>")
//            for answer:String in currentAnswers[questionInt] {
//                xmlText.append(answer + ", ")
//            }
//            // Remove last comma and space.
//            xmlText.removeLast()
//            xmlText.removeLast()
//            xmlText.append("</answer>")
//        }
//
//        // Close the section
//        xmlText.append("</section>")
//    }
    

    /********** BUTTONS FUNCTIONS **********/
    /*
     This function deletes the section from newBook and segues to the EditBook scene. It gets called when the user taps on the delete section button.
     */
    @IBAction func deleteSection(_ sender: Any) {
        // The section is not going to be updated.
        updatingSection = false
        
        // Update the xml file.
        updateXML()
        
        // Update myBook. Library doesn't store sections.
        data.myBook.sections.remove(at: data.mySectionNum)
        
        // Clear everything.
        currentQuestions = []
        currentDevices = []
        currentAnswers = []
        newAnswers = []
        textBox.text = ""
        resetSeparators()
        newQuestion.text = ""
        deviceDrop.setTitle("Select a Literary Device", for: .normal)
        newAnswer.text = ""
        answersTable.reloadData()
        questionsTable.reloadData()
        
        // Go to the EditBook scene.
        self.performSegue(withIdentifier: "EditBook", sender: self)
    }
    
    /*
     This function saves the section and segues to the EditBook scene. It gets called when the user taps on the save button.
     */
    @IBAction func saveButton(_ sender: Any) {
        // Hide errors.
        hideErrors()
        
        // Check if the section has all its pieces.
        if textBox.text != "" && separatorSelected != "" && currentQuestions.count != 0 {
            // The section is going to be updated.
            updatingSection = true
            
            // Update the xml file.
            updateXML()
            
            // Update myBook. Library doesn't store sections.
            data.myBook.sections[data.mySectionNum] = BookSection(text: NSMutableAttributedString(string: textBox.text), separator: separatorSelected, questions: currentQuestions, devices: currentDevices, answers: currentAnswers)
            
            
            // Clear everything.
            currentQuestions = []
            currentDevices = []
            currentAnswers = []
            newAnswers = []
            textBox.text = ""
            resetSeparators()
            newQuestion.text = ""
            deviceDrop.setTitle("Select a Literary Device", for: .normal)
            newAnswer.text = ""
            answersTable.reloadData()
            questionsTable.reloadData()
            
            // Go to the EditBook scene.
            self.performSegue(withIdentifier: "EditBook", sender: self)
        } else {
            oopsErrors.isHidden = false
            if textBox.text == "" {
                sectionTextError.isHidden = false
            }
            if separatorSelected == "" {
                sectionSeparatorError.isHidden = false
            }
            if currentQuestions.count == 0 {
                sectionQuestionError.isHidden = false
            }
        }
    }
    
    func updateXML() {
        // Create the string that will make up the xml file.
        xmlText = ""
        
        // Parse the file and update the current section.
        startParse()
        
        // Create xml file from string.
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let filename = path?.appendingPathComponent(data.myBook.file + ".xml")
        do {
            try xmlText.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("error in making xml file")
        }
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the EditBook scene.
        if segue.destination is EditBookViewController {
            let Destination = segue.destination as? EditBookViewController
            Destination?.data = data
        }
    }
}
