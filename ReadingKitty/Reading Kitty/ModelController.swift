//
//  ModelController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/11/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import Foundation
import UIKit

/* Contains the following:
 file: Represents the name of the file excluding the .xml. The name of the file should be the title of the book.
 sections: Represent the text broken up into sections, including the corresponding questions. The xml file must be parsed to get this info.
 */
struct Book {
    var file: String
    var sections: [BookSection]
}

/* Contains the following:
 text: An array of the text of a section of a book that has been parsed from an xml file is will be split into non-answer, answer, non-answer, etc. The answers will represent EVERY answer for EVERY question.
 questions: An array of questions for the text that has been parsed from an xml file.
 answers: An array of answers to the questions that have been parsed from an xml file.
 answerFirst: An array of bools that are true if the first string in text is an answer for the corresponding question.
*/
struct BookSection {
    var text: NSMutableAttributedString
    var questions: [String]
    var devices: [String]
    var answers: [[String]]
    var separator: String
}

/* Contains the following:
 name: The name of the student that created the video
 book: The book that the student read
 feedback: The name of the xml file that contains feedback on how the student did
 file: The name of the mp4 file that is the video
*/
struct Video {
    var name: String
    var book: Book
    var feedback: String
    var file: String
}

/* Contains the following:
 light: the lightest shade for this color scheme
 regular: the medium shade for this color scheme
 dark: the darkest shade for this color scheme
*/
struct Color {
    var light: Int
    var background: Int
    var regular: Int
    var dark: Int
}

// The model controller contains all of the data. It is constructed in each view controller and updated at each segue.
class ModelController {
    
    /********** STATIC VARIABLES **********/
    // Reading and grade level arrays. The length should be the same for both arrays.
    let readingLevels = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8"]
    let gradeLevels = ["Kindergarten", "Kindergarten", "1st Grade", "1st Grade", "2nd Grade", "2nd Grade", "3rd Grade", "3rd Grade"]
    
    // A list of lists. The books for each level are in the sub-lists.
    var allBooks = [// Level 1 books start
                    [],
                    // Level 2 books start
                    [Book(file: "There was an Old Woman Who Lived in a Shoe", sections: [])],
                    // Level 3 books start
                    [],
                    // Level 4 books start
                    [],
                    // Level 5 books start
                    [],
                    // Level 6 books start
                    [],
                    // Level 7 books start
                    [],
                    // Level 8 books start
                    []]
    
    // A list of lists. The literary devices for each level are in the sub-lists.
    let allDevices = [// Level 1 devices start
                      ["Device 1",
                       "Device 2"],
                      // Level 2 devices start
                      ["Device 2",
                       "Device 3",
                       "Device 4"],
                      // Level 3 devices start
                      ["Device 4",
                       "Device 5",
                       "Device 6"],
                      // Level 4 devices start
                      ["Device 5",
                       "Device 6",
                       "Device 7"],
                      // Level 5 devices start
                      ["Device 6",
                       "Device 7"],
                      // Level 6 devices start
                      ["Device 6",
                       "Device 7",
                       "Device 8",
                       "Device 9"],
                      // Level 7 devices start
                      ["Device 9",
                       "Device 10"],
                      // Level 8 devices start
                      ["Device 10",
                       "Device 11"]]
    
    // Color schemes
    let colors:[Color] = [Color(light: 0xFDDFDF, background: 0xFF7272, regular: 0xFF2300, dark: 0xCA0000), // red
                          Color(light: 0xFFF3E0, background: 0xFCC46C, regular: 0xFFAF3B, dark: 0xFF7900), // orange
                          Color(light: 0xFFFEE6, background: 0xFAF573, regular: 0xFEF949, dark: 0xE3E05B), // yellow
                          Color(light: 0xE1F7D9, background: 0x7DFF4D, regular: 0x79FC5F, dark: 0x5FC439), // green
                          Color(light: 0xD1F1FD, background: 0x58CFFA, regular: 0x58CEF8, dark: 0x48A5C7), // blue
                          Color(light: 0xF7E8FF, background: 0xCA76FF, regular: 0xB229FA, dark: 0x500D7B)] // purple
    
    // Standard attributes
    let standardAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 35)]
    
    
    /********** NON-STATIC VARIABLES **********/
    /*--------- TEACHER ---------*/
    // Current level
    var myLevel:Int = 0
    
    // Teacher's password
    var password:String = "password"
    
    // Security question
    var securityQuestion:String = "What is your mother's maiden name?"
    
    // Security answer
    var securityAnswer:String = "Smith"
    
    // Saved videos array
    var savedVideos:[Video] = [Video(name: "Panic!", book: Book(file: "Emperor's New Clothes!!!!", sections: []), feedback: "Love this song :)", file: "Emperor's New Clothes"),
                               Video(name: "Panic!", book: Book(file: "LA Devotee!!", sections: []), feedback: "Love this song toooooooo", file: "LA Devotee")]
    
    // Current video
    var myVideo:Int = 0
    
    /*--------- STUDENT ---------*/
    // myLevel (above)
    
    // Student's name
    var name:String = ""
    
    // Color scheme
    var myColor:Int = 3
    
    // Current book
    var myBook:Book = Book(file: "Temp Book", sections: [])
    
    // Current text in section of myBook
    var mySection:Int = 0
    
    // Current question about myText in section of myBook
    var myQuestion:Int = 0
    
    // All of the ranges for every answer in the current section. Each embedded list corresponds to one question.
    var currentRanges:[[NSRange]] = []
    
    // All of the new attributes for the current section. Each embedded list corresponds to one question.
    var currentAttributes:[[NSAttributedStringKey : Any]] = []
    
    // All of the text from myBook
    var allText:[NSMutableAttributedString] = []
    
    // All ranges
    var allRanges:[[[NSRange]]] = []
    
    // All attributes
    var allAttributes:[[[NSAttributedStringKey : Any]]] = []
    
    // Audio url of student's voice
    var audioURL:URL = URL(fileURLWithPath: "")
    
    
    /********** SHOW FUNCTIONS **********/
    /*--------- TEACHER ---------*/
    // Returns current reading level
    func getReadingLevel() -> String {
        return readingLevels[myLevel]
    }
    
    // Returns current grade level
    func getGradeLevel() -> String {
        return gradeLevels[myLevel]
    }
    
    // Returns array of current books
    func getBooks() -> [Book] {
        return allBooks[myLevel]
    }
    
    // Returns array of current literary devices
    func getDevices() -> [String] {
        return allDevices[myLevel]
    }
    
    // Returns array of saved videos titles
    func getVideoTitles() -> [String] {
        var videoTitles:[String] = []
        for video:Video in savedVideos {
            // add each video title to videoTitles
            let videoTitle:String = "\(video.name) - \(video.book.file)"
            videoTitles.append(videoTitle)
        }
        return videoTitles
    }
    
    // Returns current video
    func getVideo() -> Video {
        return savedVideos[myVideo]
    }
    
    // Returns current video title
    func getVideoTitle() -> String {
        let videoTitles:[String] = getVideoTitles()
        let videoTitle:String = videoTitles[myVideo]
        return videoTitle
    }
    
    /*--------- STUDENT ---------*/
    // Returns current light color in the color scheme
    func getColorLight(color: Int, opacity: Double) -> UIColor {
        let hex = colors[color].light
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(opacity))
        return color
    }
    
    // Returns current light color in the color scheme
    func getColorBackground(color: Int, opacity: Double) -> UIColor {
        let hex = colors[color].background
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(opacity))
        return color
    }
    
    // Returns current regular color in the color scheme
    func getColorRegular(color: Int, opacity: Double) -> UIColor {
        let hex = colors[color].regular
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(opacity))
        return color
    }
    
    // Returns current dark color in the color scheme
    func getColorDark(color: Int, opacity: Double) -> UIColor {
        let hex = colors[color].dark
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(opacity))
        return color
    }
    
    
    /********** UPDATE FUNCTIONS **********/
    /*--------- TEACHER ---------*/
    // Updates the value for myLevel
    func updateLevel(newLevel: Int) {
        myLevel = newLevel
    }

    // Updates the password
    func updatePassword(newPassword: String) {
        password = newPassword
    }
    
    // Updates the value for myVideo
    func updateVideo(newVideo: Int) {
        myVideo = newVideo
    }
    
    // Deletes the video at myVideo
    func deleteVideo() {
        savedVideos.remove(at: myVideo)
    }
    
    /*--------- STUDENT ---------*/
    // updateLevel (above)
    
    // Updates the name
    func updateName(newName: String) {
        name = newName
    }
    
    // Updates the color
    func updateColor(newColor: Int) {
        myColor = newColor
    }
    
    // Updates the book
    func updateBook(newBook: Book) {
        myBook = newBook
    }
    
    // Adds a new BookSection to myBook.sections
    func newBookSection(text:NSMutableAttributedString, questions:[String], devices:[String], answers:[[String]], separator:String) {
        myBook.sections.append(BookSection(text: text, questions: questions, devices: devices, answers: answers, separator: separator))
    }
    
    // Saves the video
    func saveVideo(feedback: String, file: String) {
        let newVideo:Video = Video(name: name, book: myBook, feedback: feedback, file: file)
        savedVideos.append(newVideo)
    }
    
    
    /********** CHECK FUNCTIONS **********/
    /*--------- TEACHER ---------*/
    // Checks the attempted password
    func checkPassword(attemptedPassword: String) -> Bool {
        if password == attemptedPassword {
            return true
        } else {
            return false
        }
    }
    
    // Checks the security answer attempt
    func checkSecurityAnswer(attemptAnswer: String) -> Bool {
        if securityAnswer == attemptAnswer {
            return true
        } else {
            return false
        }
    }
    
    /*--------- STUDENT ---------*/
}

