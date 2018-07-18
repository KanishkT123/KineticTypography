//
//  StudentBooksViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/18/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class StudentBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    /********** LOCAL VARIABLES **********/
    // Color changing objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    
    // Table
    @IBOutlet weak var booksTable: UITableView!
    
    // Parser temporary variables
    var tempCharacters: String = ""
    var tempText: String = ""
    var tempQuestions: [String] = []
    var tempDevices: [String] = []
    var tempAnswers: [[String]] = []
    var tempSeparator:String = ""
    
    // Reference to data
    var modelController:ModelController = ModelController()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //modelController = UserDefaults.standard.object(forKey: "modelController") as! ModelController
        
        // Give access to editing the table.
        booksTable.delegate = self
        booksTable.dataSource = self
        
        // Update the color scheme.
        updateColors()
    }
    
    func updateColors() {
        background.backgroundColor = modelController.getColorBackground(color: modelController.myColor, opacity: 1.0)
        header.backgroundColor = modelController.getColorLight(color: modelController.myColor, opacity: 0.8)
        booksTable.separatorColor = modelController.getColorLight(color: modelController.myColor, opacity: 1.0)
        // cells are updated in tableView below
    }
    
    // Sets the number of rows to the number of books.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.getBooks().count
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Access the current row.
        let Cell:UITableViewCell = booksTable.dequeueReusableCell(withIdentifier: "Book")!
        
        // Get book title.
        let book:Book = modelController.getBooks()[indexPath.row]
        let title:String = book.file
        
        // Input and center the title and subtitle.
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        // Update colors
        var textColor:UIColor = modelController.getColorLight(color: modelController.myColor, opacity: 1.0)
        if modelController.myColor == 2 {
            textColor = UIColor.black
        }
        Cell.backgroundColor = modelController.getColorDark(color: modelController.myColor, opacity: 0.8)
        Cell.textLabel?.textColor = textColor
        
        return Cell
    }
    

    /********** PARSING FUNCTIONS **********/
    // Parses the book.
    func startParse() {
        // Access the book file.
        let fileName = modelController.myBook.file
        let url:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName + ".xml"))!
        
        // Parse the book.
        let parser: XMLParser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
    
    // Every time the parser reads a start tag, reset tempCharacters.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        tempCharacters = ""
    }
    
    // Every time the parser reads a character, save the character to tempCharacters.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        tempCharacters += string
    }
    
    // Every time the parser reads an end tag, modify and add tempCharacters to its correct location.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "text" {
            // tempCharacters doesn't need to be modified because tempText is a string.
            // Add tempCharacters to tempText.
            tempText = tempCharacters
        }
        
        if elementName == "question" {
            // tempCharacters doesn't need to be modified because each string in tempQuestions represents an entire question.
            // Add tempCharacters to tempQuestions.
            tempQuestions.append(tempCharacters)
        }
        
        if elementName == "device" {
            // tempCharacters doesn't need to be modified because each string in tempDevices represents an entire device.
            // Add tempCharacters to tempDevices.
            tempDevices.append(tempCharacters)
        }
        
        if elementName == "answer" {
            // Modify tempCharacters from String to [String], where each string in the array is an answer.
            var charsCopy:String = tempCharacters
            //var attributesArray:[[NSAttributedStringKey : Any]] = []
            var answerArray:[String] = []
            var answer:String = ""
            while !charsCopy.isEmpty {
                // Get words from charsCopy.
                if charsCopy.contains(", ") {
                    let separator = charsCopy.range(of: ", ")!
                    answer = String(charsCopy.prefix(upTo: separator.lowerBound))
                    charsCopy.removeSubrange(charsCopy.startIndex..<separator.upperBound)
                } else {
                    answer = String(charsCopy.prefix(upTo: charsCopy.endIndex))
                    charsCopy.removeSubrange(charsCopy.startIndex..<charsCopy.endIndex)
                }
                answerArray.append(answer)
                //attributesArray.append([NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 35)])
            }
            
            // Add modified tempCharacters to tempAnswers.
            tempAnswers.append(answerArray)
        }
        
        if elementName == "separator" {
            if tempCharacters == "new line"{
                tempSeparator = "\n"
            } else if tempCharacters == "space" {
                tempSeparator = " "
            } else if tempCharacters == "none" {
                tempSeparator = ""
            }
        }
        
        if elementName == "section" {
            // Modify tempText from String to NSMutableAttributedString.
            let attributedText = NSMutableAttributedString(string: tempText, attributes: modelController.standardAttributes)
            
            // Add spacing between paragraphs.
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            paragraphStyle.paragraphSpacing = 20
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
            
            // Make a new BookSection with the collected information.
            modelController.newBookSection(text: attributedText, questions: tempQuestions, devices: tempDevices, answers: tempAnswers, separator: tempSeparator)
            // Reset all temporary variables. tempCharacters doesn't need to be reset because it is reset at every start tag.
            tempText = ""
            tempQuestions = []
            tempAnswers = []
            tempSeparator = ""
        }
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the StudentLogin scene
    @IBAction func backButton(_ sender: Any) {
        // Go to StudentLogin
        self.performSegue(withIdentifier: "StudentLevels", sender: self)
    }
    
    // If a cell is selected, go to the ... scene.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected book to myBook.
        let currentBook = modelController.getBooks()[indexPath.row]
        modelController.updateBook(newBook: currentBook)
        
        // Parse the selected book.
        startParse()
        
        // Go to the Question scene.
        self.performSegue(withIdentifier: "Question", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //UserDefaults.standard.set(modelController, forKey: "modelController")
        
        // Update the modelController in StudentLevels
        if segue.destination is StudentLevelsViewController {
            let Destination = segue.destination as? StudentLevelsViewController
            Destination?.modelController = modelController
        }

        // Update the modelController in Question
        if segue.destination is QuestionViewController {
            let Destination = segue.destination as? QuestionViewController
            Destination?.modelController = modelController
        }
    }
}
