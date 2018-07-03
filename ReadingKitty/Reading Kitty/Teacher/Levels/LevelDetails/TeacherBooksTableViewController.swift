//
//  TeacherBooksTableViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/13/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class TeacherBooksTableViewController: UITableViewController {
    /********** LOCAL VARIABLES **********/
    // TableView
    @IBOutlet var booksTable: UITableView!
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewDidLoad() {
        super.viewDidLoad()
        booksTable.delegate = self
        booksTable.dataSource = self
    }

    // Sets the number of rows to the number of books
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.getBooks().count
    }
    
    // Configures each cell by row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Accesses the current row
        let Cell:UITableViewCell = booksTable.dequeueReusableCell(withIdentifier: "Book")!
        
        // Gets devices title
        let book:Book = modelController.getBooks()[indexPath.row]
        let title = book.file
        
        // Inputs and centers (supposedly) the title
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        return Cell
    }
}
