//
//  NewBookLevelViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/10/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit
import Foundation

class NewBookLevelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    /********** LOCAL VARIABLES **********/
    // Header
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    // Book info
    var bookDevices:[String] = []
    
    // Error message
    @IBOutlet weak var error: UILabel!
    
    // Level devices
    var bookDevicesPerLevel: [[String]] = []
    var levelRankings: [Int] = []
    var levelSelected: Int = 0
    
    // Rank 1
    @IBOutlet weak var rank1Level: UILabel!
    @IBOutlet weak var rank1Table: UITableView!
    
    // Rank 2
    @IBOutlet weak var rank2Level: UILabel!
    @IBOutlet weak var rank2Table: UITableView!
    
    // Rank 3
    @IBOutlet weak var rank3Level: UILabel!
    @IBOutlet weak var rank3Table: UITableView!
    
    // Rank 4
    @IBOutlet weak var rank4Level: UILabel!
    @IBOutlet weak var rank4Table: UITableView!
    
    // Rank 5
    @IBOutlet weak var rank5Level: UILabel!
    @IBOutlet weak var rank5Table: UITableView!
    
    // Rank 6
    @IBOutlet weak var rank6Level: UILabel!
    @IBOutlet weak var rank6Table: UITableView!
    
    // Rank 7
    @IBOutlet weak var rank7Level: UILabel!
    @IBOutlet weak var rank7Table: UITableView!
    
    // Rank 8
    @IBOutlet weak var rank8Level: UILabel!
    @IBOutlet weak var rank8Table: UITableView!
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modelController = UserDefaults.standard.object(forKey: "modelController") as! ModelController
        rank1Table.delegate = self
        rank1Table.dataSource = self
        rank2Table.delegate = self
        rank2Table.dataSource = self
        rank3Table.delegate = self
        rank3Table.dataSource = self
        rank4Table.delegate = self
        rank4Table.dataSource = self
        rank5Table.delegate = self
        rank5Table.dataSource = self
        rank6Table.delegate = self
        rank6Table.dataSource = self
        rank7Table.delegate = self
        rank7Table.dataSource = self
        rank8Table.delegate = self
        rank8Table.dataSource = self
        
        // Set the header.
        bookTitleLabel.text = modelController.myBook.file
        bookTitleLabel.baselineAdjustment = .alignCenters
        
        // Hide the error.
        error.isHidden = true
        
        // Rank the levels depending on the devices asked about in the story.
        updateBookDevices()
        rankLevels()
        updateRanking()
    }
    
    /*
     This function fills bookDevices with all of the devices that show up in currentBook. The devices in currentBook may have repetition, but bookDevices should not have repetition.
    */
    func updateBookDevices() {
        // The third element in each section in currentBook represents the devices in that section.
        for section:BookSection in modelController.myBook.sections {
            let sectionDevices:[String] = section.devices
            for device:String in sectionDevices {
                // The following if statement checks for repetition before added the device to bookDevices.
                if !bookDevices.contains(device) {
                    bookDevices.append(device)
                }
            }
        }
    }
    
    /*
     This function first fills bookDevicesPerLevel so that each element represents the devices in a level that appear in the book. Then, the function fills levelRankings so that each element represents a level. The levels are ranked where the zeroth element is the most recommended level.
     
     Variables:
        levelDevicesAll: all of the devices assigned to the current level.
        levelDevicesBook: all of the devices in the current level that appeaer in the book.
    */
    
    func rankLevels() {
        // Update bookDevicesPerLevel.
        for level in 0..<8 {
            let levelDevicesAll:[String] = modelController.allDevices[level]
            var levelDevicesBook:[String] = []
            for device:String in levelDevicesAll {
                // The following if statement checks if the device appears in the book.
                if bookDevices.contains(device) {
                    levelDevicesBook.append(device)
                }
            }
            bookDevicesPerLevel.append(levelDevicesBook)
        }
        
        // Update levelRankings.
        var count:Int = 0
        while levelRankings.count != 8 {
            for level in (0..<8).reversed() {
                let levelDevices:[String] = bookDevicesPerLevel[level]
                if levelDevices.count == count {
                    levelRankings.insert(level, at: 0)
                }
            }
            count += 1
        }
    }
    
    func updateRanking() {
        let levelLabels:[String] = ["Level 1 (Kindergarten)", "Level 2 (Kindergarten)", "Level 3 (1st Grade)", "Level 4 (1st Grade)", "Level 5 (2nd Grade)", "Level 6 (2nd Grade)", "Level 7 (3rd Grade)", "Level 8 (3rd Grade)"]
        
        // Update rank labels.
        rank1Level.text = levelLabels[levelRankings[0]]
        rank2Level.text = levelLabels[levelRankings[1]]
        rank3Level.text = levelLabels[levelRankings[2]]
        rank4Level.text = levelLabels[levelRankings[3]]
        rank5Level.text = levelLabels[levelRankings[4]]
        rank6Level.text = levelLabels[levelRankings[5]]
        rank7Level.text = levelLabels[levelRankings[6]]
        rank8Level.text = levelLabels[levelRankings[7]]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == rank1Table {
            let numRows = bookDevicesPerLevel[levelRankings[0]].count
            
            return numRows
        } else if tableView == rank2Table {
            return bookDevicesPerLevel[levelRankings[1]].count
        } else if tableView == rank3Table {
            return bookDevicesPerLevel[levelRankings[2]].count
        } else if tableView == rank4Table {
            return bookDevicesPerLevel[levelRankings[3]].count
        } else if tableView == rank5Table {
            return bookDevicesPerLevel[levelRankings[4]].count
        } else if tableView == rank6Table {
            return bookDevicesPerLevel[levelRankings[5]].count
        } else if tableView == rank7Table {
            return bookDevicesPerLevel[levelRankings[6]].count
        } else {
            return bookDevicesPerLevel[levelRankings[7]].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Find the level for the current rank
        var level:Int = 0
        if tableView == rank1Table {
            level = levelRankings[0]
        } else if tableView == rank2Table {
            level = levelRankings[1]
        } else if tableView == rank3Table {
            level = levelRankings[2]
        } else if tableView == rank4Table {
            level = levelRankings[3]
        } else if tableView == rank5Table {
            level = levelRankings[4]
        } else if tableView == rank6Table {
            level = levelRankings[5]
        } else if tableView == rank7Table {
            level = levelRankings[6]
        } else if tableView == rank8Table {
            level = levelRankings[7]
        }
        
        // Access the current row.
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Device", for: indexPath)
        
        // Set title
        print(bookDevicesPerLevel[level][indexPath.row])
        Cell.textLabel?.text = bookDevicesPerLevel[level][indexPath.row]
        
        return Cell
    }

    
    /********** SEGUE FUNCTIONS **********/
    // When the user clicks on the "select level" button, it saves the level selected, saves the book as an xml file, and segues to the TeacherWelcome scene
    @IBAction func rank1Button(_ sender: Any) {
        // Save the level selected
        levelSelected = levelRankings[0]
        
        // Save the book as an xml file
        saveToXML()
        
        // Segue to the TeacherWelcome scene
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    @IBAction func rank2Button(_ sender: Any) {
        // Save the level selected
        levelSelected = levelRankings[1]
        
        // Save the book as an xml file
        saveToXML()
        
        // Segue to the TeacherWelcome scene
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    @IBAction func rank3Button(_ sender: Any) {
        // Save the level selected
        levelSelected = levelRankings[2]
        
        // Save the book as an xml file
        saveToXML()
        
        // Segue to the TeacherWelcome scene
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    @IBAction func rank4Button(_ sender: Any) {
        // Save the level selected
        levelSelected = levelRankings[3]
        
        // Save the book as an xml file
        saveToXML()
        
        // Segue to the TeacherWelcome scene
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    @IBAction func rank5Button(_ sender: Any) {
        // Save the level selected
        levelSelected = levelRankings[4]
        
        // Save the book as an xml file
        saveToXML()
        
        // Segue to the TeacherWelcome scene
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    @IBAction func rank6Button(_ sender: Any) {
        // Save the level selected
        levelSelected = levelRankings[5]
        
        // Save the book as an xml file
        saveToXML()
        
        // Segue to the TeacherWelcome scene
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    @IBAction func rank7Button(_ sender: Any) {
        // Save the level selected
        levelSelected = levelRankings[6]
        
        // Save the book as an xml file
        saveToXML()
        
        // Segue to the TeacherWelcome scene
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    @IBAction func rank8Button(_ sender: Any) {
        // Save the level selected
        levelSelected = levelRankings[7]
        
        // Save the book as an xml file
        saveToXML()
        
        // Segue to the TeacherWelcome scene
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    
    // Saves book as an xml file
    func saveToXML() {
        // Create string that will make up the xml file
        var xmlText = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
        xmlText.append("<article>")
        
        // Add each section to xmlText
        for section:BookSection in modelController.myBook.sections {
            // Start the section
            xmlText.append("<section>")
            
            // Add the text
            xmlText.append("<text>")
            xmlText.append(section.text.string)
            xmlText.append("</text>")
            
            // Add the separator
            xmlText.append("<separator>")
            xmlText.append(section.separator)
            xmlText.append("</separator>")
            
            // Add each question, device, and answers
            for question in 0..<section.questions.count {
                // Add the question
                xmlText.append("<question>")
                xmlText.append(section.questions[question])
                xmlText.append("</question>")
                
                // Add the device
                xmlText.append("<device>")
                xmlText.append(section.devices[question])
                xmlText.append("</device>")
                
                // Add the answers
                xmlText.append("<answer>")
                xmlText.append(section.answers[question][0])
                xmlText.append("</answer>")
            }
            
            // Close the section
            xmlText.append("</section>")
        }
        
        // End xmlText
        xmlText.append("</article>")
        
        // Create xml file from string
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let filename = path?.appendingPathComponent(modelController.myBook.file + ".xml")
        do {
            try xmlText.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("error in making xml file")
        }
        
        // Save book in the level data in the modelController.
        modelController.allBooks[levelSelected].append(modelController.myBook)
    }
    
    func write(text: String, to fileNamed: String, folder: String = "SavedFiles") {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".xml")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(modelController, forKey: "modelController")
        
//        // Update the modelController in TeacherWelcome
//        if segue.destination is TeacherWelcomeViewController {
//            let Destination = segue.destination as? TeacherWelcomeViewController
//            Destination?.modelController = modelController
//        }
    }
}
