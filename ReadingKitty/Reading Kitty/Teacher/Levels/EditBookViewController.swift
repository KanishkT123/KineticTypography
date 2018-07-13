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
    
    // Reference to levels, books, and devices
    var modelController:ModelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    // When the view controller appears, ...
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set delegates.
        devicesTable.delegate = self
        devicesTable.dataSource = self
        sectionsTable.delegate = self
        sectionsTable.dataSource = self
        
        // Set header.
        bookTitle.text = modelController.myBook.file
        bookLevel.text = "Level \(String(modelController.myLevel))"
        
        // Set bookDevices
        updateBookDevices()
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
    
    // Sets the number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == devicesTable {
            return bookDevices.count
        } else {
            return modelController.myBook.sections.count
        }
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == devicesTable {
            // Access the current row.
            let Cell:UITableViewCell = devicesTable.dequeueReusableCell(withIdentifier: "Device")!
            
            // Set the title.
            let title:String = bookDevices[indexPath.row]
            
            // Inputs and centers (supposedly) the title
            Cell.textLabel?.text = title
            Cell.textLabel?.textAlignment = .center
            
            return Cell
        } else {
            // Access the current row.
            let Cell:SectionsTableViewCell = sectionsTable.dequeueReusableCell(withIdentifier: "section") as! SectionsTableViewCell
            Cell.delegate = self

            // Set labels and text.
            Cell.sectionLabel.text = "Section \(String(indexPath.row))"
            Cell.sectionText.text = modelController.myBook.sections[indexPath.row].text.string
            
            return Cell
        }
    }
    
    func editButtonTapped(_ sender: SectionsTableViewCell) {
        print("hi")
    }
    
    
    /// Edit buttons
}
