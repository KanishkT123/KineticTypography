//
//  EditBookViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/13/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class EditBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SectionsTableViewCellDelegate {
    /********** LOCAL VARIABLES **********/
    // Header
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookLevel: UILabel!
    
    // Tables
    @IBOutlet weak var devicesTable: UITableView!
    @IBOutlet weak var sectionsTable: UITableView!
    
    // Book info
    var bookDevices:[String] = []
    
    // UserDefaults variables.
    var myLevel:Int = 0
    var myBook:Book = Book(file: "", sections: [])
    
    
    /********** VIEW FUNCTIONS **********/
    // When the view controller appears, ...
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values.
        myLevel = UserDefaults.standard.object(forKey: "myLevel") as! Int
        myBook = UserDefaults.standard.object(forKey: "myBook") as! Book
        
        // Set delegates.
        devicesTable.delegate = self
        devicesTable.dataSource = self
        sectionsTable.delegate = self
        sectionsTable.dataSource = self
        
        // Set header.
        bookTitle.text = myBook.file
        bookTitle.baselineAdjustment = .alignCenters
        bookLevel.text = "Level \(String(myLevel + 1))"
        
        // Set bookDevices
        updateBookDevices()
    }
    
    /*
     This function fills bookDevices with all of the devices that show up in currentBook. The devices in currentBook may have repetition, but bookDevices should not have repetition.
     */
    func updateBookDevices() {
        // The third element in each section in currentBook represents the devices in that section.
        for section:BookSection in myBook.sections {
            let sectionDevices:[String] = section.devices
            for device:String in sectionDevices {
                // The following if statement checks for repetition before added the device to bookDevices.
                if !bookDevices.contains(device) {
                    bookDevices.append(device)
                }
            }
        }
    }
    
    // Sets the number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == devicesTable {
            return bookDevices.count
        } else {
            return myBook.sections.count
        }
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == devicesTable {
            // Access the current row.
            let Cell:DevicesTableViewCell = devicesTable.dequeueReusableCell(withIdentifier: "Device") as! DevicesTableViewCell
            
            // Set the label
            Cell.deviceLabel.text = bookDevices[indexPath.row]
            
            return Cell
        } else {
            // Access the current row.
            let Cell:SectionsTableViewCell = sectionsTable.dequeueReusableCell(withIdentifier: "Section") as! SectionsTableViewCell
            Cell.delegate = self

            // Set labels and text.
            Cell.sectionLabel.text = "Section \(String(indexPath.row + 1))"
            Cell.sectionText.text = myBook.sections[indexPath.row].text.string
            
            return Cell
        }
    }
    
    func editButtonTapped(_ sender: SectionsTableViewCell) {
        print("edit section button tapped")
    }
    
    
    /// Edit buttons
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the StudentLogin scene
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "LevelDetails", sender: self)
    }
    
    // When user clicks the edit header button, it sends them to the EditHeader scene.
    @IBAction func editHeader(_ sender: Any) {
        self.performSegue(withIdentifier: "EditHeader", sender: self)
    }
    
//    // Passing data
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //UserDefaults.standard.set(modelController, forKey: "modelController")
//
//        // Update the modelController in the LevelDetails scene.
//        if segue.destination is LevelDetailsViewController {
//            let Destination = segue.destination as? LevelDetailsViewController
//            Destination?.modelController = modelController
//        }
//
//        // Update the modelController in the EditHeader scene.
//        if segue.destination is EditHeaderViewController {
//            let Destination = segue.destination as? EditHeaderViewController
//            Destination?.modelController = modelController
//        }
//    }
}
