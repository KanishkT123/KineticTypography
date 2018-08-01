//
//  LoginViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/16/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    /********** LOCAL VARIABLES **********/
    // Text gathered as a result of parsing an xml file.
    //var xmlText:String = ""
    
    let parser:myParser = myParser()
    let data = Data()
    
    
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
            
            // Copy the default books from the Bundle to the documentsDirectory.
            var library:Library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
            for book:Book in data.defaultBooks {
                let bundleText:String = parser.transferFromBundle(fileName: book.file)
                
                // Make new xml file in the documentsDirectory.
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let filename = path?.appendingPathComponent(book.file + ".xml")
                do {
                    try bundleText.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    print("error in copying bundle to documents directory")
                }
                
                // Add book to library.
                library.books.append(book)
            }
            UserDefaults.standard.set(library.toDictionary(), forKey: "library")
        } else {
            // For this case, the app has already been launched before.
        }
    }
    
    
    /********** USERDEFAULTS FUNCTIONS **********/
    /*
     This function ...
    */
    func saveLibraryVariables() {
        // Create instances.
        let library = Library()
        
        // Store dictionary.
        UserDefaults.standard.set(library.toDictionary(), forKey: "library")
    }
    
    func saveTeacherVariables() {
        // The teacher's password.
        let password:String = "password"
        
        // The teacher's security question.
        let securityQuestion:String = "What is your mother's maiden name?"
        
        // The teacher's security answer.
        let securityAnswer:String = "Smith"
        
        // Save variables into UserDefaults.
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(securityQuestion, forKey: "securityQuestion")
        UserDefaults.standard.set(securityAnswer, forKey: "securityAnswer")
    }
    
    
    /********** PARSING FUNCTIONS **********/
//    /*
//     This function saves the start tag to xmlText.
//     It is called every time the parser reads a start tag.
//    */
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        xmlText += "<\(elementName)>"
//    }
//
//    /*
//     This function saves the character to xmlText.
//     It is called every time the parser reads a character.
//    */
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        xmlText += string
//    }
//
//    /*
//     This function saves the end tag to xmlText.
//     It is called every time the parser reads an end tag.
//    */
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        xmlText += "</\(elementName)>"
//    }
    
    
    /********** SEGUE FUNCTIONS **********/
    /*
     This function segues to the Welcome scene.
     It is called when the user clicks on this button.
    */
    @IBAction func button(_ sender: Any) {
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
    /*
     This function passes data at segues.
     It is called when a segue is about to occur.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the Welcome scene.
        if segue.destination is ViewController {
            let Destination = segue.destination as? ViewController
            Destination?.data = data
        }
    }
}
