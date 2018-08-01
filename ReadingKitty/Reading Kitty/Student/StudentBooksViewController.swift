//
//  StudentBooksViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/18/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class StudentBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /********** LOCAL VARIABLES **********/
    // Color changing objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    
    // Table
    @IBOutlet weak var booksTable: UITableView!
    
//    // Parser temporary variables
//    var tempCharacters: String = ""
//    var tempText: String = ""
//    var tempQuestions: [String] = []
//    var tempDevices: [String] = []
//    var tempAnswers: [[String]] = []
//    var tempSeparator:String = ""

    var parser:myParser = myParser()
    var data:Data = Data()
    var library:Library = Library()
    var levelBooks:[Book] = []
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values.
        parser.data = data
        library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
        
        // Set delegates.
        booksTable.delegate = self
        booksTable.dataSource = self
        
        // Update the color scheme.
        updateColors()
    }
    
    func updateColors() {
        let colorScheme:Color = data.colors[data.myColor]
        background.backgroundColor = colorScheme.getColorBackground(opacity: 1.0)
        header.backgroundColor = colorScheme.getColorLight(opacity: 0.8)
        booksTable.separatorColor = colorScheme.getColorLight(opacity: 1.0)
        // cells are updated in tableView below
    }
    
    // Sets the number of rows to the number of books.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        levelBooks = []
        for book:Book in library.books {
            if book.level == data.myLevel {
                levelBooks.append(book)
            }
        }
        return levelBooks.count
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Access the current row.
        let Cell:UITableViewCell = booksTable.dequeueReusableCell(withIdentifier: "Book")!
        
        // Get book title.
        let book:Book = levelBooks[indexPath.row]
        let title:String = book.file
        
        // Input and center the title and subtitle.
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        // Update colors
        let colorScheme:Color = data.colors[data.myColor]
        var textColor:UIColor = colorScheme.getColorLight(opacity: 1.0)
        if data.myColor == 2 {
            textColor = UIColor.black
        }
        Cell.backgroundColor = colorScheme.getColorDark(opacity: 0.8)
        Cell.textLabel?.textColor = textColor
        
        return Cell
    }
    

    /********** PARSING FUNCTIONS **********/
//    // Every time the parser reads a start tag, reset tempCharacters.
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        tempCharacters = ""
//    }
//
//    // Every time the parser reads a character, save the character to tempCharacters.
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        tempCharacters += string
//    }
//
//    // Every time the parser reads an end tag, modify and add tempCharacters to its correct location.
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        if elementName == "text" {
//            // tempCharacters doesn't need to be modified because tempText is a string.
//            // Add tempCharacters to tempText.
//            tempText = tempCharacters
//        }
//
//        if elementName == "question" {
//            // tempCharacters doesn't need to be modified because each string in tempQuestions represents an entire question.
//            // Add tempCharacters to tempQuestions.
//            tempQuestions.append(tempCharacters)
//        }
//
//        if elementName == "device" {
//            // tempCharacters doesn't need to be modified because each string in tempDevices represents an entire device.
//            // Add tempCharacters to tempDevices.
//            tempDevices.append(tempCharacters)
//        }
//
//        if elementName == "answer" {
//            // Modify tempCharacters from String to [String], where each string in the array is an answer.
//            var charsCopy:String = tempCharacters
//            var answerArray:[String] = []
//            var answer:String = ""
//            while !charsCopy.isEmpty {
//                // Get words from charsCopy.
//                if charsCopy.contains(", ") {
//                    let separator = charsCopy.range(of: ", ")!
//                    answer = String(charsCopy.prefix(upTo: separator.lowerBound))
//                    charsCopy.removeSubrange(charsCopy.startIndex..<separator.upperBound)
//                } else {
//                    answer = String(charsCopy.prefix(upTo: charsCopy.endIndex))
//                    charsCopy.removeSubrange(charsCopy.startIndex..<charsCopy.endIndex)
//                }
//                answerArray.append(answer)
//                //attributesArray.append([NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 35)])
//            }
//
//            // Add modified tempCharacters to tempAnswers.
//            tempAnswers.append(answerArray)
//        }
//
//        if elementName == "separator" {
//            if tempCharacters == "new line"{
//                tempSeparator = "\n"
//            } else if tempCharacters == "space" {
//                tempSeparator = " "
//            } else if tempCharacters == "none" {
//                tempSeparator = ""
//            }
//        }
//
//        if elementName == "section" {
//            // Modify tempText from String to NSMutableAttributedString.
//            let standardAttributes = data.standardAttributes
//            let attributedText = NSMutableAttributedString(string: tempText, attributes: standardAttributes)
//
//            // Add spacing between paragraphs.
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 5
//            paragraphStyle.paragraphSpacing = 20
//            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
//
//            // Make a new BookSection with the collected information.
//            let newBookSection:BookSection = BookSection(text: attributedText, separator: tempSeparator, questions: tempQuestions, devices: tempDevices, answers: tempAnswers)
//            data.myBook.sections.append(newBookSection)
//
//            // Reset all temporary variables. tempCharacters doesn't need to be reset because it is reset at every start tag.
//            tempText = ""
//            tempQuestions = []
//            tempAnswers = []
//            tempSeparator = ""
//        }
//    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the StudentLogin scene
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "StudentLevels", sender: self)
    }
    
    // If a cell is selected, go to the ... scene.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected book to myBook.
        data.myBook = levelBooks[indexPath.row]
        
        // Parse the selected book.
        parser.sectionText(fileName: data.myBook.file)
        
        // Go to the Question scene.
        self.performSegue(withIdentifier: "Question", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in StudentLevels
        if segue.destination is StudentLevelsViewController {
            let Destination = segue.destination as? StudentLevelsViewController
            Destination?.data = data
        }

        // Update the data in Question
        if segue.destination is QuestionViewController {
            let Destination = segue.destination as? QuestionViewController
            Destination?.data = data
        }
    }
}
