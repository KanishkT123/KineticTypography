//
//  StudentLevelsTableViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/15/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class StudentLevelsTableViewController: UITableViewController {
    /********** LOCAL VARIABLES **********/
    // TableView
    @IBOutlet var levelsTable: UITableView!
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    // Gives access to editing the table.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
        levelsTable.delegate = self
        levelsTable.dataSource = self
    }
    
    // Updates colors corresponding to color scheme
    func updateColors() {
        levelsTable.separatorColor = modelController.getColorLight(color: modelController.myColor, opacity: 1.0)
        // cells are updated in tableView below
    }
    
    // Sets the number of rows to the number of levels.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // When I tried this without the +1 it cut out the last level. It doesn't do this with other tables, like the literary devices table. I have no idea why this works, but for now I will keep it.
        return modelController.getReadingLevel().count + 1
    }
    
    // Configures each cell by row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Accesses the current row
        let Cell:UITableViewCell = levelsTable.dequeueReusableCell(withIdentifier: "Level")!
        
        // Gets reading title
        let readingLevel = modelController.readingLevels[indexPath.row]
        let title = readingLevel
        
        // Inputs and centers (supposedly) the title and subtitle
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        // Update colors
        var textColor:UIColor = modelController.getColorLight(color: modelController.myColor, opacity: 1.0)
        if modelController.myColor == 2 {
            textColor = UIColor.black
        }
        Cell.backgroundColor = modelController.getColorDark(color: modelController.myColor, opacity: 0.8)
        Cell.textLabel?.textColor = textColor
        
        return Cell
        
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // If a cell is selected, go to LevelBooks to provide individualized details.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected cell row to myLevel
        modelController.updateLevel(newLevel: indexPath.row)
        
        // Go to StudentBooks
        self.performSegue(withIdentifier: "StudentLevels", sender: self)
        //self.performSegue(withIdentifier: "StudentBooks", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in StudentLevels
        if segue.destination is StudentLevelsViewController {
            let Destination = segue.destination as? StudentLevelsViewController
            Destination?.modelController = modelController
            Destination?.tableSelected = true
        }
        
        // Update the modelController in StudentBooks
        if segue.destination is StudentBooksViewController {
            let Destination = segue.destination as? StudentBooksViewController
            Destination?.modelController = modelController
        }
    }
}
