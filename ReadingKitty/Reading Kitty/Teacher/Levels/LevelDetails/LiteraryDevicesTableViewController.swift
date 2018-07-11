//
//  LiteraryDevicesTableViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/11/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class LiteraryDevicesTableViewController: UITableViewController {
    /********** LOCAL VARIABLES **********/
    // TableView
    @IBOutlet var devicesTable: UITableView!
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    // Gives access to editing the table.
    override func viewDidLoad() {
        super.viewDidLoad()
        devicesTable.delegate = self
        devicesTable.dataSource = self
    }
    
    // Sets the number of rows to the number of devices
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.getDevices().count
    }
    
    // Configures each cell by row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Accesses the current row
        let Cell:UITableViewCell = devicesTable.dequeueReusableCell(withIdentifier: "Device")!
        
        // Gets devices title
        let device:String = modelController.getDevices()[indexPath.row]
        let title = device
        
        // Inputs and centers (supposedly) the title
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        return Cell
    }
}
