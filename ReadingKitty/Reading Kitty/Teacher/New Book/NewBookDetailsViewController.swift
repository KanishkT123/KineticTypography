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
    
    // New book data
    var currentQuestions:[String] = [] // [question, question, question...]
    var currentDevices:[String] = [] // [device, device, device...]
    var currentAnswers:[String] = [] // [answers, answers, answers...] answers = answer, answer, answer...
    var currentSection:[[String]] = [] // [[text], [separator], currentQuestions, currentDevices, currentAnswers]
    var currentBook:[[[String]]] = [] // [currentSection, currentSection, currentSection...]

    // Text
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var separatorDrop: UIButton!
    
    // New Question
    @IBOutlet weak var newQuestion: UITextField!
    @IBOutlet weak var deviceDrop: UIButton!
    @IBOutlet weak var newAnswers: UITextField!
    
    // All Questions
    @IBOutlet weak var questionsTable: UITableView!
    
    // Saved book title
    var bookTitle: String = ""
//
//    // Error message
//    //@IBOutlet weak var error: UITextField!
//
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
        //error.textColor = UIColor.clear
        
        // Set header
        bookTitleLabel.text = bookTitle
        bookDetails.text = "Section \(currentBook.count + 1)"
    }

    
    /********** TEXT FUNCTIONS **********/
    // separatorDrop

    
    /********** NEW QUESTION FUNCTIONS **********/
    // newQuestion, deviceDrop, addQuestion
    // When the user presses return, the text field goes inactive.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Go inactive.
        textField.resignFirstResponder()
        
        return false
    }
    
    // deviceDrop
    
    // When the add question button is tapped, the question, device, and answers are saved, and questionsTable is updated.
    @IBAction func addQuestion(_ sender: Any) {
        // Save the question details.
        currentQuestions.append(newQuestion.text!)
        //newDevices.append(<#T##newElement: String##String#>)
        currentAnswers.append(newAnswers.text!)
        
        // Clear the question details.
        newQuestion.text = ""
        //deviceDrop
        newAnswers.text = ""
        
        // Update the question table.
        questionsTable.reloadData()
    }
    
    
    /********** ALL QUESTIONS FUNCTIONS **********/
    // Sets the number of rows to the number of questions.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestions.count
    }
    
    // Configures each cell by row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Access the current row.
        let Cell:QuestionsTableViewCell = questionsTable.dequeueReusableCell(withIdentifier: "Question") as! QuestionsTableViewCell
        
        // Get the question, device, and answers.
        let question:String = currentQuestions[indexPath.row]
        let device:String = "" //currentDevices[indexPath.row]
        let answers:String = currentAnswers[indexPath.row]
        
        // Input the question, device, and answers.
        Cell.question.text = question
        Cell.device.text = device
        Cell.answers.text = answers
        
        Cell.delegate = self
        return Cell
    }
    
    // When the user taps the delete button, the question gets deleted and the table gets reloaded.
    func questionsTableViewCellDidTapDelete(_ sender: QuestionsTableViewCell) {
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
        // Previous section is deleted from newBook.
        currentSection = currentBook.removeLast()
        
        // Update bookDetails to previous section.
        bookDetails.text = "Section \(currentBook.count + 1)"
        
        // Update text to previous section.
        textBox.text = currentSection[0][0]
        // sectionDrop currentSection[1][0]
        
        // Clear new question
        newQuestion.text = ""
        // deviceDrop
        newAnswers.text = ""
        
        // Update all questions to previous section.
        currentQuestions = currentSection[2]
        currentDevices = currentSection[3]
        currentAnswers = currentSection[4]
        questionsTable.reloadData()
    }
    
    // When the new section button is tapped, the section is saved, everything is cleared, and bookDetails is updated.
    @IBAction func newSectionButton(_ sender: Any) {
        // Update newSection.
        currentSection = []
        currentSection.append([textBox.text])
        //currentSection.append([separator])
        currentSection.append(currentQuestions)
        currentSection.append(currentDevices)
        currentSection.append(currentAnswers)
        
        // Save newSection to newBook.
        currentBook.append(currentSection)
        
        // Clear everything.
        currentSection = []
        currentQuestions = []
        currentDevices = []
        currentAnswers = []
        textBox.text = ""
        // sectionDrop
        newQuestion.text = ""
        // deviceDrop
        newAnswers.text = ""
        questionsTable.reloadData()
        
        // Update bookDetails.
        bookDetails.text = "Section \(currentBook.count + 1)"
    }
    
    // When the done button is tapped, the section is saved and the app segues to the ... scene.
    @IBAction func doneButton(_ sender: Any) {
        // Update newSection.
        currentSection = []
        currentSection.append([textBox.text])
        //currentSection.append([separator])
        currentSection.append(currentQuestions)
        currentSection.append(currentDevices)
        currentSection.append(currentAnswers)
        
        // Save newSection to newBook.
        currentBook.append(currentSection)
        
        // Clear everything.
        currentSection = []
        currentQuestions = []
        currentDevices = []
        currentAnswers = []
        textBox.text = ""
        // sectionDrop
        newQuestion.text = ""
        // deviceDrop
        newAnswers.text = ""
        questionsTable.reloadData()
        
        // Go to the ... scene.
    }
    
    
    



    /********** SEGUE FUNCTIONS **********/
    // When the user clicks the back button, it sends them to the ... scene.
//    @IBAction func backButton(_ sender: Any) {
//        // Go to the ... scene.
//        //self.performSegue(withIdentifier: "", sender: self)
//    }



//    // Passing data
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Update the modelController in ...
//        if segue.destination is ViewController {
//            let Destination = segue.destination as? ViewController
//            Destination?.modelController = modelController
//            // pass bookTitle
//        }
//    }
    

}
