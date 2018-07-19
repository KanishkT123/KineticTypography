//
//  LoginViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/16/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, XMLParserDelegate {
    /********** LOCAL VARIABLES **********/
    // Text gathered as a result of parsing an xml file.
    var xmlText:String = ""
    
    
    /********** VIEW FUNCTIONS **********/
    /*
     This function either:
        (1) Copies the default books from the Bundle to the documentsDirectory and sets up the UserDefaults if the app is being launched for the first time, or
        (2) ... if the app has already been launched before.
     It is called when the view controller is about to appear.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            // For this case, the app is being launched for the first time.
            
            // Update firstLaunch to record that the app has now already been launched .
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            // Save the default data in UserDefaults.
            saveLibraryVariables()
            saveTeacherVariables()
            saveStudentVariables()
            
            // Copy the default books from the Bundle to the documentsDirectory.
            let defaultBooks:[[Book]] = UserDefaults.standard.object(forKey: "defaultBooks") as! [[Book]]
            var allBooks:[[Book]] = UserDefaults.standard.object(forKey: "allBooks") as! [[Book]]
            for level:Int in 0..<defaultBooks.count {
                for book:Book in defaultBooks[level] {
                    // Get the book's xml text from the Bundle.
                    let bundleURL:URL = URL(fileURLWithPath: Bundle.main.path(forResource: book.file, ofType: "xml")!)
                    let parser:XMLParser = XMLParser(contentsOf: bundleURL)!
                    parser.delegate = self
                    parser.parse()
                    let bundleText:String = xmlText
                    xmlText = ""
                    
                    // Make new xml file in the documentsDirectory.
                    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    let filename = path?.appendingPathComponent(book.file + ".xml")
                    do {
                        try bundleText.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
                    } catch {
                        print("error in copying bundle to documents directory")
                    }
                    
                    // Add book to allBooks in the modelController.
                    allBooks[level].append(book)
                }
            }
            UserDefaults.standard.set(allBooks, forKey: "allBooks")
        } else {
            // For this case, the app has already been launched before.
        }
    }
    
    
    /********** USERDEFAULTS FUNCTIONS **********/
    /*
     This function ...
    */
    func saveLibraryVariables() {
        // Arrays of the reading and grade levels. The length should be the same for both arrays.
        let readingLevels:[String] = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8"]
        let gradeLevels:[String] = ["Kindergarten", "Kindergarten", "1st Grade", "1st Grade", "2nd Grade", "2nd Grade", "3rd Grade", "3rd Grade"]
        
        // An array of the default books that are stored in the Bundle.
        let defaultBooks:[[Book]] = [// Level 1 books start
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
        
        // An array of the books that are stored in the documentsDirectory.
        let allBooks:[[Book]] = [[], [], [], [], [], [], [], []]
        
        // An array of the literary devices for each level.
        let allDevices:[[String]] = [// Level 1 devices start
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
        
        // An array of the color schemes.
        let colors:[Color] = [Color(light: 0xFDDFDF, background: 0xFF7272, regular: 0xFF2300, dark: 0xCA0000), // red
            Color(light: 0xFFF3E0, background: 0xFCC46C, regular: 0xFFAF3B, dark: 0xFF7900), // orange
            Color(light: 0xFFFEE6, background: 0xFAF573, regular: 0xFEF949, dark: 0xE3E05B), // yellow
            Color(light: 0xE1F7D9, background: 0x7DFF4D, regular: 0x79FC5F, dark: 0x5FC439), // green
            Color(light: 0xD1F1FD, background: 0x58CFFA, regular: 0x58CEF8, dark: 0x48A5C7), // blue
            Color(light: 0xF7E8FF, background: 0xCA76FF, regular: 0xB229FA, dark: 0x500D7B)] // purple
        
        // An array of the attributes used for unmodified text.
        let standardAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 35)]
        
        
        // The current level. Used when looking at only books in a specific level.
        let myLevel:Int = 0
        
        // Save variables into UserDefaults.
        UserDefaults.standard.set(readingLevels, forKey: "readingLevels")
        UserDefaults.standard.set(gradeLevels, forKey: "gradeLevels")
        UserDefaults.standard.set(defaultBooks, forKey: "defaultBooks")
        UserDefaults.standard.set(allBooks, forKey: "allBooks")
        UserDefaults.standard.set(allDevices, forKey: "allDevices")
        UserDefaults.standard.set(colors, forKey: "colors")
        UserDefaults.standard.set(standardAttributes, forKey: "standardAttributes")
        UserDefaults.standard.set(myLevel, forKey: "myLevel")
    }
    
    func saveTeacherVariables() {
        // The teacher's password.
        let password:String = "password"
        
        // The teacher's security question.
        let securityQuestion:String = "What is your mother's maiden name?"
        
        // The teacher's security answer.
        let securityAnswer:String = "Smith"
        
        // An array of saved videos.
        let savedVideos:[Video] = [Video(name: "Panic!", book: Book(file: "Emperor's New Clothes!!!!", sections: []), feedback: "This is a good song.", file: "Emperor's New Clothes"),
                                   Video(name: "Panic!", book: Book(file: "LA Devotee!!", sections: []), feedback: "This is a good song too.", file: "LA Devotee")]
        
        // The current video.
        let myVideo:Int = 0
        
        // Save variables into UserDefaults.
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(securityQuestion, forKey: "securityQuestion")
        UserDefaults.standard.set(securityAnswer, forKey: "securityAnswer")
        UserDefaults.standard.set(savedVideos, forKey: "savedVideos")
        UserDefaults.standard.set(myVideo, forKey: "myVideo")
    }
    
    func saveStudentVariables() {
        // The student's name
        let name:String = ""
        
        // The color scheme
        let myColor:Int = 3
        
        // The current book
        let myBook:Book = Book(file: "Temp Book", sections: [])
        
        // The current section in myBook
        let mySectionNum:Int = 0
        
        // The current question in mySection of myBook
        let myQuestionNum:Int = 0
        
        // All of the ranges for every answer in the current section. Each embedded list corresponds to one question.
        let currentRanges:[[NSRange]] = []
        
        // All of the new attributes for the current section. Each embedded list corresponds to one question.
        let currentAttributes:[[NSAttributedStringKey : Any]] = []
        
        // All of the text from myBook
        let allText:[NSMutableAttributedString] = []
        
        // All ranges
        let allRanges:[[[NSRange]]] = []
        
        // All attributes
        let allAttributes:[[[NSAttributedStringKey : Any]]] = []
        
        // Audio url of student's voice
        let audioURL:URL = URL(fileURLWithPath: "")
        
        // Save variables into UserDefaults.
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(myColor, forKey: "myColor")
        UserDefaults.standard.set(myBook, forKey: "myBook")
        UserDefaults.standard.set(mySectionNum, forKey: "mySectionNum")
        UserDefaults.standard.set(myQuestionNum, forKey: "myQuestionNum")
        UserDefaults.standard.set(currentRanges, forKey: "currentRanges")
        UserDefaults.standard.set(currentAttributes, forKey: "currentAttributes")
        UserDefaults.standard.set(allText, forKey: "allText")
        UserDefaults.standard.set(allRanges, forKey: "allRanges")
        UserDefaults.standard.set(allAttributes, forKey: "allAttributes")
        UserDefaults.standard.set(audioURL, forKey: "audioURL")
    }
    
    /********** PARSING FUNCTIONS **********/
    /*
     This function saves the start tag to xmlText.
     It is called every time the parser reads a start tag.
    */
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlText += "<\(elementName)>"
    }
    
    /*
     This function saves the character to xmlText.
     It is called every time the parser reads a character.
    */
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText += string
    }
    
    /*
     This function saves the end tag to xmlText.
     It is called every time the parser reads an end tag.
    */
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        xmlText += "</\(elementName)>"
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    /*
     This function segues to the Welcome scene.
     It is called when the user clicks on this button.
    */
    @IBAction func button(_ sender: Any) {
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
//    /*
//     This function passes data at segues.
//     It is called when a segue is about to occur.
//    */
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Update the modelController in the Welcome scene.
//        if segue.destination is ViewController {
//            let Destination = segue.destination as? ViewController
//            Destination?.modelController = modelController
//        }
//    }
}
