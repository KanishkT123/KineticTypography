//
//  EditHeaderViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/16/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class EditHeaderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /********** LOCAL VARIABLES **********/
    // Header
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookLevel: UILabel!
    
    // Book info
    var bookDevices:[String] = []
    
    // Udpate title.
    @IBOutlet weak var titleBox: UITextField!
    
    // Update level.
    var newLevel:Int = 0
    
    // Level devices
    var bookDevicesPerLevel: [[String]] = []
    var levelRankings: [Int] = []

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
    
    // UserDefaults variables.
    var data:Data = Data()
    var library:Library = Library()
    
    /********** VIEW FUNCTIONS **********/
    /*
     This function sets the delegates and header, and ranks the levels.
     It is called when the view controller is about to appear.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values.
        library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
        
        // Set newLevel
        newLevel = data.myBook.level
        
        // Rank the levels depending on the devices asked about in the story.
        updateBookDevices()
        rankLevels()
        updateRanking()
        
        // Set the delegates.
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
        bookTitle.text = data.myBook.file
        bookTitle.baselineAdjustment = .alignCenters
        bookLevel.text = "Level \(String(data.myLevel + 1))"
    }
    
    /*
     This function fills bookDevices with all of the devices that show up in currentBook. The devices in currentBook may have repetition, but bookDevices should not have repetition.
    */
    func updateBookDevices() {
        // The third element in each section in currentBook represents the devices in that section.
        for section:BookSection in data.myBook.sections {
            for device:String in section.devices {
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
        print(bookDevices)
        for level in 0..<8 {
            var levelDevicesBook:[String] = []
            print(data.allDevices[level])
            for device:String in data.allDevices[level] {
                // The following if statement checks if the device appears in the book.
                if bookDevices.contains(device) {
                    levelDevicesBook.append(device)
                }
            }
            print(levelDevicesBook)
            bookDevicesPerLevel.append(levelDevicesBook)
        }
        print(bookDevicesPerLevel)
        
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
        print(levelRankings)
    }
    
    /*
     This function updates the rank labels to match how the levels have been ranked.
    */
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
    
    /*
     This function sets the number of rows to the number of devices in the rank's level.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == rank1Table {
            return bookDevicesPerLevel[levelRankings[0]].count
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
        Cell.textLabel?.text = bookDevicesPerLevel[level][indexPath.row]
        
        return Cell
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When the user clicks on the back button, it updates the book's level, and segues to the EditBook scene.
    @IBAction func backButton(_ sender: Any) {
        // Update level in myBook.
        data.myBook.level = newLevel
        
        // Update level in library.
        for bookInt:Int in 0..<library.books.count {
            if library.books[bookInt].file == data.myBook.file {
                library.books[bookInt].level = newLevel
            }
        }
        UserDefaults.standard.set(library.toDictionary(), forKey: "library")
        
        // Segue to the EditBook scene
        self.performSegue(withIdentifier: "EditBook", sender: self)
    }
    
    // When the user clicks on the "update title" button, it updates the title. Note: Books that are premade on the app are saved in the Bundle, which is read only. Books that have been made manually in the app are saved in the FileManager, which can be edited.
    @IBAction func updateTitleButton(_ sender: Any) {
        if titleBox.text != "" {
            // Get the original and new titles.
            let originalTitle:String = data.myBook.file
            let newTitle:String = titleBox.text!
            
            // Update xml file name to title.            
            let originalFile = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(originalTitle + ".xml"))!
            let newFile = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(newTitle + ".xml"))!
            do {
                try FileManager.default.moveItem(at: originalFile, to: newFile)
            } catch {
                print("Error renaming xml file in EditHeaderViewController.")
            }
            
            // Update title in library.
            for bookInt:Int in 0..<library.books.count {
                if library.books[bookInt].file == data.myBook.file {
                    library.books[bookInt].file = newTitle
                }
            }
            UserDefaults.standard.set(library.toDictionary(), forKey: "library")
            
            // Update title in myBook.
            data.myBook.file = newTitle
            
            // Update the header.
            bookTitle.text = newTitle
        }
    }
    
    // When the user clicks on the "update level" button, it updates the level.
    @IBAction func rank1Button(_ sender: Any) {
        // Update the level.
        newLevel = levelRankings[0]
        
        // Update the header.
        bookLevel.text = "Level \(String(newLevel + 1))"
    }
    @IBAction func rank2Button(_ sender: Any) {
        // Update the level.
        newLevel = levelRankings[1]
        
        // Update the header.
        bookLevel.text = "Level \(String(newLevel + 1))"
    }
    @IBAction func rank3Button(_ sender: Any) {
        // Update the level.
        newLevel = levelRankings[2]
        
        // Update the header.
        bookLevel.text = "Level \(String(newLevel + 1))"
    }
    @IBAction func rank4Button(_ sender: Any) {
        // Update the level.
        newLevel = levelRankings[3]
        
        // Update the header.
        bookLevel.text = "Level \(String(newLevel + 1))"
    }
    @IBAction func rank5Button(_ sender: Any) {
        // Update the level.
        newLevel = levelRankings[4]
        
        // Update the header.
        bookLevel.text = "Level \(String(newLevel + 1))"
    }
    @IBAction func rank6Button(_ sender: Any) {
        // Update the level.
        newLevel = levelRankings[5]
        
        // Update the header.
        bookLevel.text = "Level \(String(newLevel + 1))"
    }
    @IBAction func rank7Button(_ sender: Any) {
        // Update the level.
        newLevel = levelRankings[6]
        
        // Update the header.
        bookLevel.text = "Level \(String(newLevel + 1))"
    }
    @IBAction func rank8Button(_ sender: Any) {
        // Update the level.
        newLevel = levelRankings[7]
        
        // Update the header.
        bookLevel.text = "Level \(String(newLevel + 1))"
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the EditBook scene.
        if segue.destination is EditBookViewController {
            let Destination = segue.destination as? EditBookViewController
            Destination?.data = data
        }
    }
}
