//
//  ModelController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/11/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import Foundation
import UIKit

/*
 Contains: structs that hold data that does not need to be saved locally
 */


/*****************************/
/********** STRUCTS **********/
/*****************************/

/*
 file: The name of the xml file, which should also be the title of the book.
 level: The reading level of the book.
 sections: An array of BookSections. The text for each section combined is the text for the whole book.
 */
struct Book {
    var file: String
    var level: Int
    var sections: [BookSection]
    
    init(file: String, level: Int, sections: [BookSection]) {
        self.file = file
        self.level = level
        self.sections = sections
    }
    
    init(dictionary dict: [String: Any]) {
        self.file = dict["file"] as! String
        self.level = dict["level"] as! Int
        self.sections = []
        if let sectionDictList = dict["sections"] as? [[String: Any]] {
            for sectionDict in sectionDictList {
                self.sections.append(BookSection(dictionary: sectionDict))
            }
        }
    }
    
    func toDictionary() -> [String: Any] {
        return ["file": file,
                "level": level,
                "sections": sections.map({ $0.toDictionary() })]
    }
}

/*
 text: A section of the book's text.
 separator: Either "new line", "space", or "none". This represents how the text in this section will be separated from the text in the next section. The last section's separator should be "none".
 questions: An array of questions for the text.
 devices: An array of literary devices that correspond to the questions array.
 answers: An array of answers that correspond to the questions array.
 */
struct BookSection {
    var text: NSMutableAttributedString
    var separator: String
    var questions: [String]
    var devices: [String]
    var answers: [[String]]
    
    init(text: NSMutableAttributedString, separator: String, questions: [String], devices: [String], answers: [[String]]) {
        self.text = text
        self.separator = separator
        self.questions = questions
        self.devices = devices
        self.answers = answers
    }
    
    init(dictionary dict: [String: Any]) {
        self.text = dict["text"] as! NSMutableAttributedString
        self.separator = dict["separator"] as! String
        self.questions = dict["questions"] as! [String]
        self.devices = dict["devices"] as! [String]
        self.answers = dict["answers"] as! [[String]]
    }
    
    func toDictionary() -> [String: Any] {
        return ["text": text,
                "separator": separator,
                "questions": questions,
                "devices": devices,
                "answers": answers]
    }
}

/*
 books: An array of all of the books stored locally on the device.
 videos: An array of all of the videos stored locally on the device.
 */
struct Library {
    var books: [Book]
    var videos: [Video]
    
    init() {
        self.books = []
        self.videos = []
    }
    
    init(dictionary dict: [String: Any]) {
        self.books = []
        if let booksDictList = dict["books"] as? [[String: Any]] {
            for booksDict in booksDictList {
                self.books.append(Book(dictionary: booksDict))
            }
        }
        
        self.videos = []
        if let videosDictList = dict["videos"] as? [[String: Any]] {
            for videosDict in videosDictList {
                self.videos.append(Video(dictionary: videosDict))
            }
        }
    }
    
    func toDictionary() -> [String: Any] {
        return ["books": books.map({ $0.toDictionary()}),
                "videos": videos.map({ $0.toDictionary() })]
    }
}

/*
 name: The name of the student that created the video.
 book: The book that the student read.
 feedback: The name of the xml file that contains feedback on how the student did.
 file: The name of the mp4 file that contains the kinetic typography video.
 */
struct Video {
    var name: String
    var bookTitle: String
    var feedback: String
    var file: String
    
    init(name: String, bookTitle: String, feedback: String, file: String) {
        self.name = name
        self.bookTitle = bookTitle
        self.feedback = feedback
        self.file = file
    }
    
    init(dictionary dict: [String: Any]) {
        self.name = dict["name"] as! String
        self.bookTitle = dict["bookTitle"] as! String
        self.feedback = dict["feedback"] as! String
        self.file = dict["file"] as! String
    }
    
    func toDictionary() -> [String: Any] {
        return ["name": name,
                "bookTitle": bookTitle,
                "feedback": feedback,
                "file": file]
    }
}

/*
 light: the lightest shade for this color scheme.
 background: the background view's shade for this color scheme.
 regular: the medium shade for this color scheme.
 dark: the darkest shade for this color scheme.
 */
struct Color {
    var light: Int
    var background: Int
    var regular: Int
    var dark: Int
    
    init(light: Int, background: Int, regular: Int, dark: Int) {
        self.light = light
        self.background = background
        self.regular = regular
        self.dark = dark
    }
    
    init(dictionary dict: [String: Any]) {
        self.light = dict["light"] as! Int
        self.background = dict["background"] as! Int
        self.regular = dict["regular"] as! Int
        self.dark = dict["dark"] as! Int
    }
    
    func toDictionary() -> [String: Any] {
        return ["light": light,
                "background": background,
                "regular": regular,
                "dark": dark]
    }
    
    func getColorLight(opacity: Double) -> UIColor {
        let hex = self.light
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(opacity))
        return color
    }
    
    func getColorBackground(opacity: Double) -> UIColor {
        let hex = self.background
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(opacity))
        return color
    }
    
    func getColorRegular(opacity: Double) -> UIColor {
        let hex = self.regular
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(opacity))
        return color
    }
    
    func getColorDark(opacity: Double) -> UIColor {
        let hex = self.dark
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(opacity))
        return color
    }
}


/**************************/
/********** DATA **********/
/**************************/

struct Data {
    let readingLevels:[String] = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8"]
    let gradeLevels:[String] = ["Kindergarten", "Kindergarten", "1st Grade", "1st Grade", "2nd Grade", "2nd Grade", "3rd Grade", "3rd Grade"]
    let allDevices:[[String]] = [["Device 1", "Device 2"],
                                 ["Device 2", "Device 3", "Device 4"],
                                 ["Device 4", "Device 5", "Device 6"],
                                 ["Device 5", "Device 6", "Device 7"],
                                 ["Device 6", "Device 7"],
                                 ["Device 6", "Device 7", "Device 8", "Device 9"],
                                 ["Device 9", "Device 10"],
                                 ["Device 10", "Device 11"]]
    // Note: level should be from 0 to 7, not 1 to 8
    let defaultBooks = [Book(file: "There was an Old Woman Who Lived in a Shoe", level: 1, sections: [])]
    
    // Teacher Data
    var myLevel:Int = 0
    var myVideo:Int = 0
    
    // Student Data
    var name:String = ""
    var myColor:Int = 3
    let colors:[Color] = [Color(light: 0xFDDFDF, background: 0xFF7272, regular: 0xFF2300, dark: 0xCA0000), // red
        Color(light: 0xFFF3E0, background: 0xFCC46C, regular: 0xFFAF3B, dark: 0xFF7900), // orange
        Color(light: 0xFFFEE6, background: 0xFAF573, regular: 0xFEF949, dark: 0xE3E05B), // yellow
        Color(light: 0xE1F7D9, background: 0x7DFF4D, regular: 0x79FC5F, dark: 0x5FC439), // green
        Color(light: 0xD1F1FD, background: 0x58CFFA, regular: 0x58CEF8, dark: 0x48A5C7), // blue
        Color(light: 0xF7E8FF, background: 0xCA76FF, regular: 0xB229FA, dark: 0x500D7B)] // purple
    var myBook:Book = Book(file: "", level: 0, sections: [])
    var myBookInt:Int = 0
    let standardAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 35)]
    var mySectionNum:Int = 0
    var myQuestionNum:Int = 0
    var currentRanges:[[NSRange]] = []
    var currentAttributes:[[NSAttributedStringKey : Any]] = []
    var allText:[NSMutableAttributedString] = []
    var allRanges:[[[NSRange]]] = []
    var allAttributes:[[[NSAttributedStringKey : Any]]] = []
    var audioURL:URL = URL(fileURLWithPath: "")
    var maxFrequency:Double = 0.0
    var minFrequency:Double = 1000.0
}

class myParser: UIViewController, XMLParserDelegate {
    var section:Bool = false
    
    var data:Data = Data()
    
    // Parser temporary variables
    // For student books and level details
    var tempCharacters: String = ""
    var tempText: String = ""
    var tempQuestions: [String] = []
    var tempDevices: [String] = []
    var tempAnswers: [[String]] = []
    var tempSeparator:String = ""
    
    // For login
    var xmlText:String = ""
    
    // For edit section
    var parsingSection:Int = 0
    var updatingSection:Bool = false
    var deletingSection:Bool = false
    
    
    /*
     This function parses the book.
    */
    func startParse(fileName:String, updateSection:Bool, deleteSection:Bool) {
        // Access the book file.
        let url:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName + ".xml"))!
        
        updatingSection = updateSection
        deletingSection = deleteSection
        if updatingSection || deletingSection {
            section = false
        } else {
            section = true
        }
        
        // Parse the book.
        let parser: XMLParser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
    
    func transferFromBundle(fileName:String) -> String {
        section = false
        xmlText = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
        
        // Access the book file from the Bundle.
        let bundleURL:URL = URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "xml")!)
        
        // Parse the book.
        let parser:XMLParser = XMLParser(contentsOf: bundleURL)!
        parser.delegate = self
        parser.parse()
        
        return xmlText
    }
    
    // Every time the parser reads a start tag, reset tempCharacters.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if section {
            // For student books and level details
            tempCharacters = ""
        } else if parsingSection == data.mySectionNum {
            if updatingSection {
                // For this case, this section is being updated.
                if elementName == "section" {
                    // Add the updated section rather than the old section.
                    newSection()
                }
            } else if deletingSection {
                // For this case, this section is being deleted.
            }
        } else {
            xmlText.append("<\(elementName)>")
        }
    }
    
    // Every time the parser reads a character, save the character to tempCharacters.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        tempCharacters.append(string)
    }
    
    // Every time the parser reads an end tag, modify and add tempCharacters to its correct location.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if section {
            // For student books and level details
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
                let standardAttributes = data.standardAttributes
                let attributedText = NSMutableAttributedString(string: tempText, attributes: standardAttributes)
                
                // Add spacing between paragraphs.
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 5
                paragraphStyle.paragraphSpacing = 20
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
                
                // Make a new BookSection with the collected information.
                let newBookSection:BookSection = BookSection(text: attributedText, separator: tempSeparator, questions: tempQuestions, devices: tempDevices, answers: tempAnswers)
                data.myBook.sections.append(newBookSection)
                
                // Reset all temporary variables. tempCharacters doesn't need to be reset because it is reset at every start tag.
                tempText = ""
                tempQuestions = []
                tempAnswers = []
                tempSeparator = ""
            }
        } else if parsingSection == data.mySectionNum {
            if updatingSection {
                // For this case, this section is being updated.
                if elementName == "section" {
                    // Add the updated section rather than the old section.
                    newSection()
                }
            } else if deletingSection {
                // For this case, this section is being deleted.
            }
        } else {
            xmlText.append(tempCharacters)
            xmlText.append("</\(elementName)>")
            tempCharacters = ""
        }
        
        if elementName == "section" {
            // This is the end of a section, so the next section will now be parsed.
            parsingSection += 1
        }
    }
    
    func newSection() {
        // Start the section
        xmlText.append("<section>")
        
        // Add the text
        xmlText.append("<text>")
        xmlText.append(textBox.text)
        xmlText.append("</text>")
        
        // Add the separator
        xmlText.append("<separator>")
        xmlText.append(separatorSelected)
        xmlText.append("</separator>")
        
        // Add each question, device, and answers
        for questionInt:Int in 0..<currentQuestions.count {
            // Add the question
            xmlText.append("<question>")
            xmlText.append(currentQuestions[questionInt])
            xmlText.append("</question>")
            
            // Add the device
            xmlText.append("<device>")
            xmlText.append(currentDevices[questionInt])
            xmlText.append("</device>")
            
            // Add the answers
            print(currentAnswers)
            xmlText.append("<answer>")
            for answer:String in currentAnswers[questionInt] {
                xmlText.append(answer + ", ")
            }
            // Remove last comma and space.
            xmlText.removeLast()
            xmlText.removeLast()
            xmlText.append("</answer>")
        }
        
        // Close the section
        xmlText.append("</section>")
    }
    
    
}

extension UIViewController {
    func answerVariations(answer:String) -> [String] {
        // Find all of the variations of the answer.
        let punctuation:[String] = ["\(answer)", "\(answer).", "\(answer),", "\(answer)?", "\(answer)!"]
        let endQuote:[String] = ["\(answer)\"", "\(answer).\"", "\(answer),\"", "\(answer)?\"", "\(answer)!\""]
        let startQuote:[String] = ["\"\(answer)", "\"\(answer).", "\"\(answer),", "\"\(answer)?", "\"\(answer)!"]
        let startEndQuote:[String] = ["\"\(answer)\"", "\"\(answer).\"", "\"\(answer),\"", "\"\(answer)?\"", "\"\(answer)!\""]
        
        // Compile all of the variations.
        var variation:[String] = []
        variation.append(contentsOf: punctuation)
        variation.append(contentsOf: endQuote)
        variation.append(contentsOf: startQuote)
        variation.append(contentsOf: startEndQuote)
        
        return variation
    }
}

extension XMLParserDelegate {
    func startParse(fileName:String) {
        // Access the book file.
        let url:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName + ".xml"))!
        
        // Parse the book.
        let parser: XMLParser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
}




