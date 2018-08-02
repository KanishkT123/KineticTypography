//
//  LevelDetailsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/11/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class LevelDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BooksTableViewCellDelegate {
    /********** LOCAL VARIABLES **********/
    // Label
    @IBOutlet weak var readingLevel: UILabel!
    @IBOutlet weak var gradeLevel: UILabel!
    
    // Tables
    @IBOutlet weak var devicesTable: UITableView!
    @IBOutlet weak var booksTable: UITableView!
    
    // Parser temporary variables
    var tempCharacters: String = ""
    var tempText: String = ""
    var tempQuestions: [String] = []
    var tempDevices: [String] = []
    var tempAnswers: [[String]] = []
    var tempSeparator:String = ""
    
//    var parser:myParser = myParser()
    var data:Data = Data()
    var library:Library = Library()
    var levelBooks:[Book] = []

    
    /********** VIEW FUNCTIONS **********/
    // When view controller appears, set the correct level as the header
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values
        //parser.data = data
        library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
        
        // Set delegates.
        devicesTable.delegate = self
        devicesTable.dataSource = self
        booksTable.delegate = self
        booksTable.dataSource = self
        
        // Set header.
        readingLevel.text = data.readingLevels[data.myLevel]
        gradeLevel.text = data.gradeLevels[data.myLevel]
    }
    
    // Sets the number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == devicesTable {
            return data.allDevices[data.myLevel].count
        } else {
            levelBooks = []
            for book:Book in library.books {
                if book.level == data.myLevel {
                    levelBooks.append(book)
                }
            }
            return levelBooks.count
        }
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == devicesTable {
            // Access the current row.
            let Cell:UITableViewCell = devicesTable.dequeueReusableCell(withIdentifier: "Device")!
            
            // Set the title.
            let title:String = data.allDevices[data.myLevel][indexPath.row]
            
            // Inputs and centers (supposedly) the title
            Cell.textLabel?.text = title
            Cell.textLabel?.textAlignment = .center
            
            return Cell
        } else {
            // Access the current row.
            let Cell:BooksTableViewCell = booksTable.dequeueReusableCell(withIdentifier: "Book") as! BooksTableViewCell
            Cell.delegate = self
            
            // Create book label.
            Cell.book.text = levelBooks[indexPath.row].file
            
            return Cell
        }
    }
    
    
    /********** PARSING FUNCTIONS **********/
//    // Parses the book.
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
//
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
    // When user clicks the back button, it send them to the TeacherLevels scene
    @IBAction func backButton(_ sender: Any) {
        // Go to the TeacherLevels scene.
        self.performSegue(withIdentifier: "TeacherLevels", sender: self)
    }
    
    // When the user taps on the edit button, it sends them to the EditBook scene
    func editButtonTapped(_ sender: BooksTableViewCell) {
        // Get the book's index.
        guard let tappedIndexPath = booksTable.indexPath(for: sender) else { return }
        
        // Update the selected book.
        var myBookInt:Int = tappedIndexPath.row
        for bookInt:Int in 0..<library.books.count {
            if library.books[bookInt].level == data.myLevel {
                if myBookInt == 0 {
                    data.myBookInt = bookInt
                }
                myBookInt -= 1
            }
        }
        data.myBook = library.books[data.myBookInt]
        
        
        
        // Go to the EditBook scene.
        self.performSegue(withIdentifier: "EditBook", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the TeacherLevels scene.
        if segue.destination is TeacherLevelsViewController {
            let Destination = segue.destination as? TeacherLevelsViewController
            Destination?.data = data
        }

        // Update the data in the EditBook scene
        if segue.destination is EditBookViewController {
            let Destination = segue.destination as? EditBookViewController
            Destination?.data = data
        }
    }
}
