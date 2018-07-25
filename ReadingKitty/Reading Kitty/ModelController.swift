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
    let standardAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 35)]
    var mySectionNum:Int = 0
    var myQuestionNum:Int = 0
    var currentRanges:[[NSRange]] = []
    var currentAttributes:[[NSAttributedStringKey : Any]] = []
    var allText:[NSMutableAttributedString] = []
    var allRanges:[[[NSRange]]] = []
    var allAttributes:[[[NSAttributedStringKey : Any]]] = []
    var audioURL:URL = URL(fileURLWithPath: "")
}
