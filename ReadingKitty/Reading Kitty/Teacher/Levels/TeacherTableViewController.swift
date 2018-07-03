//
//  TeacherTableViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/11/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class TeacherTableViewController: UITableViewController {
    /********** LOCAL VARIABLES **********/
    // TableView
    @IBOutlet weak var levelsTable: UITableView!
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    // Gives access to editing the table.
    override func viewDidLoad() {
        super.viewDidLoad()
        levelsTable.delegate = self
        levelsTable.dataSource = self
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
        
        // Gets reading title and grade subtitle
        let readingLevel = modelController.readingLevels[indexPath.row]
        let title = readingLevel
        
        let gradeLevel = modelController.gradeLevels[indexPath.row]
        let subtitle = gradeLevel
        
        // Inputs and centers (supposedly) the title and subtitle
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center

        Cell.detailTextLabel?.text = subtitle
        Cell.detailTextLabel?.textAlignment = .center
        
        return Cell
        
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // If a cell is selected, go to LevelDetails to provide individualized details.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected cell row to myLevel
        modelController.updateLevel(newLevel: indexPath.row)
        
        // Go to TeacherLevels
        print("going to teacher levels")
        self.performSegue(withIdentifier: "TeacherLevels", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in TeacherLevels
        if segue.destination is TeacherLevelsViewController {
            let Destination = segue.destination as? TeacherLevelsViewController
            Destination?.modelController = modelController
            Destination?.tableSelected = true
        }
    }
}
