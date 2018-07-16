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
    // True if this is the first launch. Can only be set true in AppDelegate.
    var firstLaunch:Bool = false
    
    // Text gathered as a result of parsing.
    var parsedText:String = ""
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If this is the first time the app has launched, the default books will be copied into the documents directory.
        if firstLaunch {
            firstLaunch = false
            for level:Int in 0..<modelController.defaultBooks.count {
                for book:Book in modelController.defaultBooks[level] {
                    // Get text from bundle.
                    let bundleURL:URL = URL(fileURLWithPath: Bundle.main.path(forResource: book.file, ofType: "xml")!)
                    let parser:XMLParser = XMLParser(contentsOf: bundleURL)!
                    parser.delegate = self
                    parser.parse()
                    let bundleText:String = parsedText
                    parsedText = ""
                    
                    // Make new xml file in documents directory.
                    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    let filename = path?.appendingPathComponent(book.file + ".xml")
                    do {
                        try bundleText.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
                    } catch {
                        print("error in copying bundle to documents directory")
                    }
                    
                    // Add book to allBooks
                    modelController.allBooks[level].append(book)
                }
            }
        }
    }
    
    
    /********** PARSING FUNCTIONS **********/
    // Every time the parser reads a start tag, save start tag to parsedText.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        parsedText += "<\(elementName)>"
    }
    
    // Every time the parser reads a character, save the character to parsedText.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        parsedText += string
    }
    
    // Every time the parser reads an end tag, save the end tag to parsedText.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        parsedText += "</\(elementName)>"
    }
    
    
    
    
    @IBAction func button(_ sender: Any) {
        // Go to the Welcome scene.
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }
    
    // Pass shared data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in the Welcome scene.
        if segue.destination is ViewController {
            let Destination = segue.destination as? ViewController
            Destination?.modelController = modelController
        }
    }
}
