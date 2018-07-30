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
    // bookTitle: UILabel!
    // bookSection: UILabel!

    // Book data
    var currentQuestions:[String] = [] // [question, question, ... ]
    var currentDevices:[String] = [] // [device, device, ... ]
    var currentAnswers:[[String]] = [] // [answers, answers, ...]
                                        // answers = [answer, answer, ... ]

    // Text
    // textBox: UITextView!
    
    // Separators
//    @IBOutlet weak var newLineBackground: UIView!
//    @IBOutlet weak var spaceBackground: UIView!
//    @IBOutlet weak var noneBackground: UIView!
//    @IBOutlet weak var newLineLabel: UILabel!
//    @IBOutlet weak var spaceLabel: UILabel!
//    @IBOutlet weak var noneLabel: UILabel!
//    @IBOutlet weak var newLineExample: UILabel!
//    @IBOutlet weak var spaceExample: UILabel!
//    @IBOutlet weak var noneExample: UILabel!

    // New Question
//    @IBOutlet weak var newQuestion: UITextField!
//    @IBOutlet weak var dropStack: UIStackView!
//    @IBOutlet weak var deviceDrop: UIButton!
//    var deviceButtons: [UIButton] = []
//    @IBOutlet weak var newAnswer: UITextField!
//    var newAnswers: [String] = []
//    @IBOutlet weak var answersTable: UITableView!
    
    // All Questions
    // questionsTable: UITableView
    
    // Error messages
//    @IBOutlet weak var oopsErrors: UILabel!
//    @IBOutlet weak var questionQuestionError: UILabel!
//    @IBOutlet weak var questionDeviceError: UILabel!
//    @IBOutlet weak var questionAnswerError: UILabel!
//    @IBOutlet weak var sectionTextError: UILabel!
//    @IBOutlet weak var sectionSeparatorError: UILabel!
//    @IBOutlet weak var sectionQuestionError: UILabel!
//    @IBOutlet weak var answerError: UILabel!
    
    // UserDefaults variables.
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
        library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
        
        // Set delegates.
        //textBox.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func deleteButtonTapped(_ sender: AnswersTableViewCell) {
        <#code#>
    }
    
    func deleteButtonTapped(_ sender: QuestionsTableViewCell) {
        <#code#>
    }

}
