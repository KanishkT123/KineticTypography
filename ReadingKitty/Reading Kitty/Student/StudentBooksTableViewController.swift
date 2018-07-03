//
//  StudentBooksTableViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/18/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class StudentBooksTableViewController: UITableViewController, XMLParserDelegate {
    /********** LOCAL VARIABLES **********/
    // TableView
    @IBOutlet var booksTable: UITableView!
    
    // Reference to shared data
    var modelController = ModelController()
    
    // Parser temporary variables
    var tempCharacters: String = ""
    var tempText: String = ""
    var tempQuestions: [String] = []
    var tempAnswers: [[String]] = []
    var tempSeparator:String = ""
    
    /********** VIEW FUNCTIONS **********/
    // Gives access to editing the table.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update the color scheme
        updateColors()
        
        // Give access to editing the table.
        booksTable.delegate = self
        booksTable.dataSource = self
    }
    
    // Updates colors corresponding to color scheme. The cells are updated in tableView().
    func updateColors() {
        booksTable.separatorColor = modelController.getColorLight(color: modelController.myColor, opacity: 1.0)
    }
    
    // Sets the number of rows to the number of books.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.getBooks().count
    }
    
    // Configures each cell by row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        let path = Bundle.main.path(forResource: fileName, ofType: "xml")
        
        // Parse the book.
        let parser: XMLParser = XMLParser(contentsOf: URL(fileURLWithPath: path!))!
        parser.delegate = self;
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
            modelController.newBookSection(text: attributedText, questions: tempQuestions, answers: tempAnswers, separator: tempSeparator)
            
            // Reset all temporary variables. tempCharacters doesn't need to be reset because it is reset at every start tag.
            tempText = ""
            tempQuestions = []
            tempAnswers = []
            tempSeparator = ""
        }
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // If a cell is selected, go to the QuestionInstructions scene.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected cell row to myBook.
        let currentBook = modelController.getBooks()[indexPath.row]
        modelController.updateBook(newBook: currentBook)
        
        // Parse the selected book.
        startParse()
        
        // Go to QuestionInstructions scene.
        self.performSegue(withIdentifier: "StudentBooks", sender: self)
    }
    
    // Pass shared data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in StudentBooks.
        if segue.destination is StudentBooksViewController {
            let Destination = segue.destination as? StudentBooksViewController
            Destination?.modelController = modelController
            Destination?.tableSelected = true
        }
    }
    

}
