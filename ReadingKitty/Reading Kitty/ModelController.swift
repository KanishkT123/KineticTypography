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
    
    // Parsing variables.
    private var xmlText:String = ""
    private var currentSection:Int = 0
    
    // Parsing categories.
    private var sectioning:Bool = false
    private var deleteSection:Bool = false
    private var insertSection:Bool = false
    private var updateSection:Bool = false
    
    // New section variables.
    private var newText:String = ""
    private var newSeparator:String = ""
    private var newQuestions:[String] = []
    private var newDevices:[String] = []
    private var newAnswers:[[String]] = []

    // Sectioning variables.
    private var tempText: String = ""
    private var tempQuestions: [String] = []
    private var tempDevices: [String] = []
    private var tempAnswers: [[String]] = []
    private var tempSeparator:String = ""
    
    // Keeping track of data.
    var data:Data = Data()
    
    
    
    /*
     This function creates an xml file of a book from provided BookSections. It is called in the following view controllers: NewBookLevel.
     */
    func newBook(fileName:String, sections:[BookSection]) {
        // Create the beginning of the xml file.
        xmlText = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
        xmlText.append("<article>")
        
        // Add each section to xmlTetx.
        for section:BookSection in sections {
            // Save the new section data.
            newText = section.text.string
            newSeparator = section.separator
            newQuestions = section.questions
            newDevices = section.devices
            newAnswers = section.answers
            
            // Add the new section.
            addSection()
        }
        
        // End xmlText.
        xmlText.append("</article>")
        
        // Save xmlText to the documents directory.
        saveXML(fileName: fileName, xmlString: xmlText)
    }
    
    
    /*
     This function moves an xml file from the bundle to the documents directory. It is called in the following view controllers: Login.
     */
    func bundleToDocuments(fileName:String) {
        // The text is just being extracted.
        sectioning = false
        deleteSection = false
        insertSection = false
        updateSection = false
        
        // Parse the book.
        startParse(fileName: fileName, bundle: true)
        
        // Save xmlText to the documents directory.
        saveXML(fileName: fileName, xmlString: xmlText)
    }
    
    /*
     This function sections an xml file into BookSections in data.myBook. It is called in the following view controllers: StudentBooks and LevelDetails.
     */
    func sectionBook(fileName:String) -> [BookSection] {
        // The book is being sectioned into BookSections.
        sectioning = true
        deleteSection = false
        insertSection = false
        updateSection = false
        
        // Parse the book.
        data.myBook.sections = []
        startParse(fileName: fileName, bundle: false)
        return data.myBook.sections
    }
    
    /*
     This function deletes the section at data.mySectionNum. It is called in the following view controllers: EditSection.
     */
    func deleteSection(fileName:String) {
        // A section is being deleted.
        sectioning = false
        deleteSection = true
        insertSection = false
        updateSection = false
        
        // Parse the book.
        startParse(fileName: fileName, bundle: false)
        
        // Save xmlText to the documents directory.
        saveXML(fileName: fileName, xmlString: xmlText)
    }
    
    /*
     This function inserts a section at data.mySectionNum. It is called in the following view controllers: .
     */
    func insertSection(fileName:String, text:String, separator:String, questions:[String], devices:[String], answers:[[String]]) {
        // A section is being inserted.
        sectioning = false
        deleteSection = false
        insertSection = true
        updateSection = false
        
        // Save the new section data.
        newText = text
        newSeparator = separator
        newQuestions = questions
        newDevices = devices
        newAnswers = answers
        
        // Parse the book.
        startParse(fileName: fileName, bundle: false)
        
        // Save xmlText to the documents directory.
        saveXML(fileName: fileName, xmlString: xmlText)
    }
    
    /*
     This function updates the section at data.mySectionNum. It is called in the following view controllers: EditSection.
     */
    func updateSection(fileName:String, text:String, separator:String, questions:[String], devices:[String], answers:[[String]]) {
        // A section is being updated.
        sectioning = false
        deleteSection = false
        insertSection = false
        updateSection = true
        
        // Save the new section data.
        newText = text
        newSeparator = separator
        newQuestions = questions
        newDevices = devices
        newAnswers = answers
//        print("text:")
//        print(newText)
//        print("separator:")
//        print(newSeparator)
//        print("questions:")
//        print(newQuestions)
//        print("devices:")
//        print(newDevices)
//        print("answers:")
//        print(newAnswers)
        
        // Parse the book.
        startParse(fileName: fileName, bundle: false)
        
        // Save xmlText to the documents directory.
        saveXML(fileName: fileName, xmlString: xmlText)
    }
    
    /*
     This function saves an xml string to an xml file in the documents directory. It is called in the following functions: newBook(), bundleToDocuments(), deleteSection(), insertSection, updateSection().
     */
    private func saveXML(fileName:String, xmlString:String) {
        let url:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let xmlURL:URL = url.appendingPathComponent(fileName + ".xml")
        do {
            try xmlString.write(to: xmlURL, atomically: true, encoding: String.Encoding.utf8)
            print("Saving xml:")
            print(xmlString)
        } catch {
            print("error in making xml file")
        }
    }
    
    /*
     This function parses the book.
    */
    private func startParse(fileName:String, bundle:Bool) {
        // Access the book file.
        var url:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName + ".xml"))!
        xmlText = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
        
        // Check if the book is in the bundle.
        if bundle {
            url = URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "xml")!)
        }
        
        // Check if the book is being sectioned.
        if sectioning {
            xmlText = ""
        }
        
        let parser: XMLParser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
    
    
    /*
     This function is called when the parser reads a start tag.
    */
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if sectioning {
            // For this case, the text is being sectioned. Reset xmlText to keep track of this element tag's text.
            xmlText = ""
        } else if deleteSection && currentSection == data.mySectionNum {
            // For this case, this section is being deleted.
        } else if insertSection && currentSection == data.mySectionNum {
            // For this case, a new section is being added.
            addSection()
            
            // This section is also being extracted.
            xmlText.append("<\(elementName)>")
        } else if updateSection && currentSection == data.mySectionNum {
            // For this case, a new section is being added.
            addSection()
            
            // This section is being deleted because it has been replaced.
            deleteSection = true
        } else {
            // For this case, this section is being extracted.
            xmlText.append("<\(elementName)>")
        }
    }
    
    /*
     This function is called when the parser reads a character.
    */
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText.append(string)
    }
    
    /*
     This function is called when the parser reads an end tag.
    */
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if sectioning {
            // For this case, the text is being sectioned.
            if elementName == "text" {
                // For this case, xmlText had been collecting the section's text.
                tempText = xmlText
            }
            
            if elementName == "question" {
                // For this case, xmlText had been collecting a question.
                tempQuestions.append(xmlText)
            }
            
            if elementName == "device" {
                // For this case, xmlText had been collecting a device.
                tempDevices.append(xmlText)
            }
            
            if elementName == "answer" {
                // For this case, xmlText had been collecting an answer. xml files store answers as a String in "answer, answer, ..." form. BookSections store answers as a [String] in ["answer", "answer", ...] form.
                
                // Create answersArray (how BookSections store answers) from answersString (how xml files store answers).
                var answersString:String = xmlText
                var answersArray:[String] = []
                var answer:String = ""
                while !answersString.isEmpty {
                    if answersString.contains(", ") {
                        // For this case, there are multiple answers left in answersString. Save the first answer and remove it from answersString.
                        let separator = answersString.range(of: ", ")!
                        answer = String(answersString.prefix(upTo: separator.lowerBound))
                        answersString.removeSubrange(answersString.startIndex..<separator.upperBound)
                    } else {
                        // For this case, there is one answer left in answersString. Save this answer and remove it from answersString.
                        answer = String(answersString.prefix(upTo: answersString.endIndex))
                        answersString.removeSubrange(answersString.startIndex..<answersString.endIndex)
                    }
                    
                    // Add the saved answer to answersArray.
                    answersArray.append(answer)
                }
                
                // Add answersArray (the answers for this question) to tempAnswers (the answers for this section).
                tempAnswers.append(answersArray)
            }
            
            if elementName == "separator" {
                // For this case, xmlText had been collecting a separator.
                if xmlText == "New Line"{
                    tempSeparator = "\n"
                } else if xmlText == "Space" {
                    tempSeparator = " "
                } else if xmlText == "None" {
                    tempSeparator = ""
                }
            }
            
            if elementName == "section" {
                // For this case, an entire section has been collected. This section needs to be created into a BookSection and added to myBook.
                
                // A BookSection needs an attributedString representing its text.
                let attributedString = NSMutableAttributedString(string: tempText, attributes: data.standardAttributes)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 5
                paragraphStyle.paragraphSpacing = 20
                attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
                
                // Create the new BookSection and add it to myBook.
                let newBookSection:BookSection = BookSection(text: attributedString, separator: tempSeparator, questions: tempQuestions, devices: tempDevices, answers: tempAnswers)
                data.myBook.sections.append(newBookSection)
                // Reset the temporary variables.
                tempText = ""
                tempSeparator = ""
                tempQuestions = []
                tempDevices = []
                tempAnswers = []
            }
        } else if deleteSection && currentSection == data.mySectionNum {
            // For this case, this section is being deleted.
            currentSection += 1
        } else {
            // For this case, this section is being extracted.
            xmlText.append("</\(elementName)>")
            currentSection += 1
        }
    }
    
    
    private func addSection() {
        // Start the section.
        xmlText.append("<section>")
        
        // Add the text.
        xmlText.append("<text>")
        xmlText.append(newText)
        xmlText.append("</text>")
        
        // Add the separator
        xmlText.append("<separator>")
        xmlText.append(newSeparator)
        xmlText.append("</separator>")
        
        // Add each question, device, and answers
        for questionInt:Int in 0..<newQuestions.count {
            // Add the question
            xmlText.append("<question>")
            xmlText.append(newQuestions[questionInt])
            xmlText.append("</question>")
            
            // Add the device
            xmlText.append("<device>")
            xmlText.append(newDevices[questionInt])
            xmlText.append("</device>")
            
            // Add the answers
            xmlText.append("<answer>")
            for answer:String in newAnswers[questionInt] {
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
