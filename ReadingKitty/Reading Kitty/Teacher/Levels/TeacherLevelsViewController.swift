//
//  TeacherLevelsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/8/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class TeacherLevelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /********** LOCAL VARIABLES **********/
    // Table
    @IBOutlet weak var levelsTable: UITableView!
    
    // UserDefaults variables.
    var data:Data = Data()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set delegates.
        levelsTable.delegate = self
        levelsTable.dataSource = self
    }
    
    // Sets the number of rows to the number of levels.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.readingLevels.count
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Accesses the current row
        let Cell:UITableViewCell = levelsTable.dequeueReusableCell(withIdentifier: "Level")!
        
        // Gets reading title and grade subtitle
        let readingLevel = data.readingLevels[indexPath.row]
        let title = readingLevel
        
        let gradeLevel = data.gradeLevels[indexPath.row]
        let subtitle = gradeLevel
        
        // Inputs and centers (supposedly) the title and subtitle
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        Cell.detailTextLabel?.text = subtitle
        Cell.detailTextLabel?.textAlignment = .center
        
        return Cell
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the TeacherWelcome scene
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    
    // If a cell is selected, go to the LevelDetails scene.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected cell row to myLevel.
        data.myLevel = indexPath.row
        
        // Go to the LevelDetails scene.
        self.performSegue(withIdentifier: "LevelDetails", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in TeacherWelcome
        if segue.destination is TeacherWelcomeViewController {
            let Destination = segue.destination as? TeacherWelcomeViewController
            Destination?.data = data
        }

        // Update the data in LevelDetails
        if segue.destination is LevelDetailsViewController {
            let Destination = segue.destination as? LevelDetailsViewController
            Destination?.data = data
        }
    }
}
