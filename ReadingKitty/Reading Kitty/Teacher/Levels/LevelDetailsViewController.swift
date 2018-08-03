//
//  LevelDetailsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/11/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class LevelDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BooksTableViewCellDelegate {
    /********** LOCAL VARIABLES **********/
    // Label
    @IBOutlet weak var readingLevel: UILabel!
    @IBOutlet weak var gradeLevel: UILabel!
    
    // Tables
    @IBOutlet weak var devicesTable: UITableView!
    @IBOutlet weak var booksTable: UITableView!
    
    // Parser temporary variables
    var tempCharacters: String = ""
    var tempText: String = ""
    var tempQuestions: [String] = []
    var tempDevices: [String] = []
    var tempAnswers: [[String]] = []
    var tempSeparator:String = ""
    
//    var parser:myParser = myParser()
    var data:Data = Data()
    var library:Library = Library()
    var levelBooks:[Book] = []

    
    /********** VIEW FUNCTIONS **********/
    // When view controller appears, set the correct level as the header
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values
        library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
        
        // Set delegates.
        devicesTable.delegate = self
        devicesTable.dataSource = self
        booksTable.delegate = self
        booksTable.dataSource = self
        
        // Set header.
        readingLevel.text = data.readingLevels[data.myLevel]
        gradeLevel.text = data.gradeLevels[data.myLevel]
    }
    
    // Sets the number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == devicesTable {
            return data.allDevices[data.myLevel].count
        } else {
            levelBooks = []
            for book:Book in library.books {
                if book.level == data.myLevel {
                    levelBooks.append(book)
                }
            }
            return levelBooks.count
        }
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == devicesTable {
            // Access the current row.
            let Cell:UITableViewCell = devicesTable.dequeueReusableCell(withIdentifier: "Device")!
            
            // Set the title.
            let title:String = data.allDevices[data.myLevel][indexPath.row]
            
            // Inputs and centers (supposedly) the title
            Cell.textLabel?.text = title
            Cell.textLabel?.textAlignment = .center
            
            return Cell
        } else {
            // Access the current row.
            let Cell:BooksTableViewCell = booksTable.dequeueReusableCell(withIdentifier: "Book") as! BooksTableViewCell
            Cell.delegate = self
            
            // Create book label.
            Cell.book.text = levelBooks[indexPath.row].file
            
            return Cell
        }
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the TeacherLevels scene
    @IBAction func backButton(_ sender: Any) {
        // Go to the TeacherLevels scene.
        self.performSegue(withIdentifier: "TeacherLevels", sender: self)
    }
    
    // When the user taps on the edit button, it sends them to the EditBook scene
    func editButtonTapped(_ sender: BooksTableViewCell) {
        // Get the book's index.
        guard let tappedIndexPath = booksTable.indexPath(for: sender) else { return }
        
        // Update the selected book.
        var myBookInt:Int = tappedIndexPath.row
        for bookInt:Int in 0..<library.books.count {
            if library.books[bookInt].level == data.myLevel {
                if myBookInt == 0 {
                    data.myBookInt = bookInt
                }
                myBookInt -= 1
            }
        }
        data.myBook = library.books[data.myBookInt]
        
        // Go to the EditBook scene.
        self.performSegue(withIdentifier: "EditBook", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in the TeacherLevels scene.
        if segue.destination is TeacherLevelsViewController {
            let Destination = segue.destination as? TeacherLevelsViewController
            Destination?.data = data
        }

        // Update the data in the EditBook scene
        if segue.destination is EditBookViewController {
            let Destination = segue.destination as? EditBookViewController
            Destination?.data = data
        }
    }
}
