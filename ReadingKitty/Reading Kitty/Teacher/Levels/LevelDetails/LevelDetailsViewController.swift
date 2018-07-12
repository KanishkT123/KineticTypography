//
//  LevelDetailsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/11/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class LevelDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    /********** LOCAL VARIABLES **********/
    // Label
    @IBOutlet weak var readingLabel: UILabel!
    
    // Tables
    @IBOutlet weak var devicesTable: UITableView!
    @IBOutlet weak var booksTable: UITableView!
    
    // Parser temporary variables
    var tempCharacters: String = ""
    var tempText: String = ""
    var tempQuestions: [String] = []
    var tempAnswers: [[String]] = []
    var tempSeparator:String = ""
    
    // Reference to levels, books, and devices
    var modelController:ModelController = ModelController()

    
    /********** VIEW FUNCTIONS **********/
    // When view controller appears, set the correct level as the header
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set delegates.
        devicesTable.delegate = self
        devicesTable.dataSource = self
        booksTable.delegate = self
        booksTable.dataSource = self
        
        // Set header.
        readingLabel.text = modelController.getReadingLevel()
    }
    
    // Sets the number of rows to the number of devices.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == devicesTable {
            return modelController.getDevices().count
        } else {
            return modelController.getBooks().count
        }
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Accesses the cell
        var Cell:UITableViewCell = devicesTable.dequeueReusableCell(withIdentifier: "Device")!
        if tableView == booksTable {
            Cell = booksTable.dequeueReusableCell(withIdentifier: "Book")!
        }
        
        // Set the title.
        var title:String = modelController.getDevices()[indexPath.row]
        if tableView == booksTable {
            title = modelController.getBooks()[indexPath.row].file
        }
        
        // Inputs and centers (supposedly) the title
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        return Cell
    }
    
    
    /********** PARSING FUNCTIONS **********/
    // Parses the book. Note: Books that are premade on the app are saved in the Bundle, which is read only. Books that have been made manually in the app are saved in the FileManager, which can be edited.
    func startParse() {
        // Access the book file.
        let fileName = modelController.myBook.file
        
        // Assign the path, as if the book is in the Bundle.
        let path = Bundle.main.path(forResource: fileName, ofType: "xml")
        
        // If the path does not exist, then the book is in the FileManager. Assign the url accordingly.
        var url:URL = URL(fileURLWithPath: "")
        if path == nil {
            url = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName + ".xml"))!
        } else {
            url = URL(fileURLWithPath: path!)
        }
        
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
    // When user clicks the back button, it send them to the TeacherLevels scene
    @IBAction func backButton(_ sender: Any) {
        // Go to TeacherLevels
        self.performSegue(withIdentifier: "TeacherLevels", sender: self)
    }
    
    // If a cell is selected, go to the ... scene.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check which table view is being selected.
        if tableView == booksTable {
            // Updated the selected book to myBook.
            let currentBook = modelController.getBooks()[indexPath.row]
            modelController.updateBook(newBook: currentBook)
            
            // Parse the selected book.
            startParse()
            
            // Go to the ... scene.
            self.performSegue(withIdentifier: "...", sender: self)
        }
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in TeacherLevels
        if segue.destination is TeacherLevelsViewController {
            let Destination = segue.destination as? TeacherLevelsViewController
            Destination?.modelController = modelController
        }
    }
}
