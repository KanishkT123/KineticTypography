//
//  NewBookDetailsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/3/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class NewBookDetailsViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, QuestionsTableViewCellDelegate {
    /********** LOCAL VARIABLES **********/
    // Header
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookDetails: UILabel!
    var bookTitle: String = ""
    
    // New book data
    var currentQuestions:[String] = [] // [question, question, question...]
    var currentDevices:[String] = [] // [device, device, device...]
    var currentAnswers:[String] = [] // [answers, answers, answers...] answers = answer, answer, answer...
    var currentSection:[[String]] = [] // [[text], [separator], currentQuestions, currentDevices, currentAnswers]
    var currentBook:[[[String]]] = [] // [currentSection, currentSection, currentSection...]

    // Text
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var separatorDrop: UIButton!
    @IBOutlet var separatorButtons: [UIButton]!
    
    // New Question
    @IBOutlet weak var newQuestion: UITextField!
    @IBOutlet weak var deviceDrop: UIButton!
    @IBOutlet var deviceButtons: [UIButton]!
    @IBOutlet weak var newAnswers: UITextField!
    
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
    
    // Reference to levels, books, and devices
    var modelController = ModelController()


    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textBox.delegate = self
        newQuestion.delegate = self
        newAnswers.delegate = self
        questionsTable.delegate = self
        questionsTable.dataSource = self
        
        // Set header
        bookTitleLabel.text = bookTitle
        bookDetails.text = "Section \(currentBook.count + 1)"
        
        // Hide errors
        oopsErrors.isHidden = true
        questionQuestionError.isHidden = true
        questionDeviceError.isHidden = true
        questionAnswerError.isHidden = true
        sectionTextError.isHidden = true
        sectionSeparatorError.isHidden = true
        sectionQuestionError.isHidden = true
    }

    
    /********** TEXT FUNCTIONS **********/
    // When the select a separator button is selected, the drop down menu is shown.
    @IBAction func separatorDrop(_ sender: Any) {
        // Show or hide buttons
        separatorButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum Separators: String {
        case newLine = "New Line"
        case space = "Space"
        case none = "None"
    }
    
    // When a separator is selected, the select separator button's title is updated and the drop down menu is hidden.
    @IBAction func separatorTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let separator = Separators(rawValue: title) else { return }
        
        switch separator {
        case .newLine:
            separatorDrop.setTitle("New Line", for: .normal)
        case .space:
            separatorDrop.setTitle("Space", for: .normal)
        default:
            separatorDrop.setTitle("None", for: .normal)
        }
        
        // Hide buttons
        separatorButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    /********** NEW QUESTION FUNCTIONS **********/
    // newQuestion, deviceDrop, addQuestion
    // When the user presses return, the text field goes inactive.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Go inactive.
        textField.resignFirstResponder()
        
        return false
    }
    
    // When the select a device button is selected, the drop down menu is shown.
    @IBAction func deviceDrop(_ sender: Any) {
        // Show or hide buttons
        deviceButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum Devices: String {
        case device1 = "Device 1"
        case device2 = "Device 2"
        case device3 = "Device 3"
        case device4 = "Device 4"
        case device5 = "Device 5"
        case device6 = "Device 6"
        case device7 = "Device 7"
        case device8 = "Device 8"
        case device9 = "Device 9"
        case device10 = "Device 10"
        case device11 = "Device 11"
    }
    
    @IBAction func deviceTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let device = Devices(rawValue: title) else { return }
        
        switch device {
        case .device1:
            deviceDrop.setTitle("Device 1", for: .normal)
        case .device2:
            deviceDrop.setTitle("Device 2", for: .normal)
        case .device3:
            deviceDrop.setTitle("Device 3", for: .normal)
        case .device4:
            deviceDrop.setTitle("Device 4", for: .normal)
        case .device5:
            deviceDrop.setTitle("Device 5", for: .normal)
        case .device6:
            deviceDrop.setTitle("Device 6", for: .normal)
        case .device7:
            deviceDrop.setTitle("Device 7", for: .normal)
        case .device8:
            deviceDrop.setTitle("Device 8", for: .normal)
        case .device9:
            deviceDrop.setTitle("Device 9", for: .normal)
        case .device10:
            deviceDrop.setTitle("Device 10", for: .normal)
        default:
            deviceDrop.setTitle("Device 11", for: .normal)
        }
        
        // Hide buttons
        deviceButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // When the add question button is tapped, the question, device, and answers are saved, and questionsTable is updated.
    @IBAction func addQuestion(_ sender: Any) {
        // Hide errors
        oopsErrors.isHidden = true
        questionQuestionError.isHidden = true
        questionDeviceError.isHidden = true
        questionAnswerError.isHidden = true
        sectionTextError.isHidden = true
        sectionSeparatorError.isHidden = true
        sectionQuestionError.isHidden = true
        
        // Check if new question has all pieces
        if newQuestion.text != "" && deviceDrop.currentTitle != "Select a Literary Device" && newAnswers.text != "" {
            // Save the question details.
            currentQuestions.append(newQuestion.text!)
            currentDevices.append(deviceDrop.currentTitle!)
            currentAnswers.append(newAnswers.text!)
            
            // Clear the question details.
            newQuestion.text = ""
            deviceDrop.setTitle("Select a Literary Device", for: .normal)
            newAnswers.text = ""
            
            // Update the question table.
            questionsTable.reloadData()
        } else {
            oopsErrors.isHidden = false
            if newQuestion.text == "" {
                questionQuestionError.isHidden = false
            } else {
                questionQuestionError.isHidden = true
            }
            if deviceDrop.currentTitle == "Select a Literary Device" {
                questionDeviceError.isHidden = false
            } else {
                questionDeviceError.isHidden = true
            }
            if newAnswers.text == "" {
                questionAnswerError.isHidden = false
            } else {
                questionAnswerError.isHidden = true
            }
        }
    }
    
    
    /********** ALL QUESTIONS FUNCTIONS **********/
    // Sets the number of rows to the number of questions.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestions.count
    }
    
    // Configures each cell by row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        Cell.answers.text = currentAnswers[indexPath.row]
        Cell.answers.textColor = textBox.backgroundColor
        Cell.answers.font = Cell.answers.font.withSize(20.0)

        // Create delete button.
        Cell.deleteButton.frame = CGRect(x: 850, y: 0, width: 80, height: 100)
        Cell.deleteButton.backgroundColor = UIColor.clear
        Cell.deleteButton.setTitle("Delete", for: .normal)
        Cell.deleteButton.setTitleColor(UIColor.black, for: .normal)
        
        return Cell
    }
    
    // When the user taps the delete button, the question gets deleted and the table gets reloaded.
    func deleteButtonTapped(_ sender: QuestionsTableViewCell) {
        // Get the question's index.
        guard let tappedIndexPath = questionsTable.indexPath(for: sender) else { return }
        
        // Delete the question.
        currentQuestions.remove(at: tappedIndexPath.row)
        currentDevices.remove(at: tappedIndexPath.row)
        currentAnswers.remove(at: tappedIndexPath.row)
        
        // Update the question table.
        questionsTable.reloadData()
    }
    
    

    
    /********** BUTTONS FUNCTIONS **********/
    // When the delete section button is tapped, the previous section is deleted newBook, and the screen matches the previous section's data.
    @IBAction func deleteSectionButton(_ sender: Any) {
        // Hide errors
        oopsErrors.isHidden = true
        questionQuestionError.isHidden = true
        questionDeviceError.isHidden = true
        questionAnswerError.isHidden = true
        sectionTextError.isHidden = true
        sectionSeparatorError.isHidden = true
        sectionQuestionError.isHidden = true
        
        if currentBook.count == 0 {
            // Clear new question
            newQuestion.text = ""
            deviceDrop.setTitle("Select a Literary Device", for: .normal)
            newAnswers.text = ""
            
            // Segue to the NewBook scene.
            self.performSegue(withIdentifier: "NewBook", sender: self)
        } else {
            // Previous section is deleted from newBook.
            currentSection = currentBook.removeLast()
            
            // Update bookDetails to previous section.
            bookDetails.text = "Section \(currentBook.count + 1)"
            
            // Update text to previous section.
            textBox.text = currentSection[0][0]
            separatorDrop.setTitle(currentSection[1][0], for: .normal)
            
            // Update all questions to previous section.
            currentQuestions = currentSection[2]
            currentDevices = currentSection[3]
            currentAnswers = currentSection[4]
            questionsTable.reloadData()
            
            // Clear new question
            newQuestion.text = ""
            deviceDrop.setTitle("Select a Literary Device", for: .normal)
            newAnswers.text = ""
        }
    }
    
    // When the new section button is tapped, the section is saved, everything is cleared, and bookDetails is updated.
    @IBAction func newSectionButton(_ sender: Any) {
        // Update newSection.
        currentSection = []
        currentSection.append([textBox.text])
        currentSection.append([separatorDrop.currentTitle!])
        currentSection.append(currentQuestions)
        currentSection.append(currentDevices)
        currentSection.append(currentAnswers)
        
        // Hide errors
        oopsErrors.isHidden = true
        questionQuestionError.isHidden = true
        questionDeviceError.isHidden = true
        questionAnswerError.isHidden = true
        sectionTextError.isHidden = true
        sectionSeparatorError.isHidden = true
        sectionQuestionError.isHidden = true
        
        // Check if new section has all pieces
        if currentSection[0][0] != "" && currentSection[1][0] != "Select a Separator" && currentSection[2].count != 0 {
            // Save newSection to newBook.
            currentBook.append(currentSection)
            
            // Clear everything.
            currentSection = []
            currentQuestions = []
            currentDevices = []
            currentAnswers = []
            textBox.text = ""
            separatorDrop.setTitle("Select a Separator", for: .normal)
            newQuestion.text = ""
            deviceDrop.setTitle("Select a Literary Device", for: .normal)
            newAnswers.text = ""
            questionsTable.reloadData()
            
            // Update bookDetails.
            bookDetails.text = "Section \(currentBook.count + 1)"
        } else {
            oopsErrors.isHidden = false
            if currentSection[0][0] == "" {
                sectionTextError.isHidden = false
            }
            if currentSection[1][0] == "Select a Separator" {
                sectionSeparatorError.isHidden = false
            }
            if currentSection[2].count == 0 {
                sectionQuestionError.isHidden = false
            }
        }
    }
    
    // When the done button is tapped, the section is saved and the app segues to the NewBookLevel scene.
    @IBAction func doneButton(_ sender: Any) {
        // Update newSection.
        currentSection = []
        currentSection.append([textBox.text])
        currentSection.append([separatorDrop.currentTitle!])
        currentSection.append(currentQuestions)
        currentSection.append(currentDevices)
        currentSection.append(currentAnswers)
        
        // Hide errors
        oopsErrors.isHidden = true
        questionQuestionError.isHidden = true
        questionDeviceError.isHidden = true
        questionAnswerError.isHidden = true
        sectionTextError.isHidden = true
        sectionSeparatorError.isHidden = true
        sectionQuestionError.isHidden = true
        
        // Check if new section has all pieces
        if currentSection[0][0] != "" && currentSection[1][0] != "Select a Separator" && currentSection[2].count != 0 {
            // Save newSection to newBook.
            currentBook.append(currentSection)
            
            // Clear everything.
            currentSection = []
            currentQuestions = []
            currentDevices = []
            currentAnswers = []
            textBox.text = ""
            separatorDrop.setTitle("Select a Separator", for: .normal)
            newQuestion.text = ""
            deviceDrop.setTitle("Select a Literary Device", for: .normal)
            newAnswers.text = ""
            questionsTable.reloadData()
            
            // Update bookDetails.
            bookDetails.text = "Section 1"
            
            // Go to the NewBookLevel scene.
            self.performSegue(withIdentifier: "NewBookLevel", sender: self)
        } else {
            oopsErrors.isHidden = false
            if currentSection[0][0] == "" {
                sectionTextError.isHidden = false
            }
            if currentSection[1][0] == "Select a Separator" {
                sectionSeparatorError.isHidden = false
            }
            if currentSection[2].count == 0 {
                sectionQuestionError.isHidden = false
            }
        }
    }
    

    /********** SEGUE FUNCTIONS **********/
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in NewBook
        if segue.destination is NewBookViewController {
            let Destination = segue.destination as? NewBookViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelController in NewBookLevel
        if segue.destination is NewBookLevelViewController {
            let Destination = segue.destination as? NewBookLevelViewController
            Destination?.modelController = modelController
            Destination?.bookTitle = bookTitle
            Destination?.currentBook = currentBook
        }
    }
}
