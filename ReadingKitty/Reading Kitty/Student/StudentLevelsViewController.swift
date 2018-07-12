//
//  StudentLevelsViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/15/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class StudentLevelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /********** LOCAL VARIABLES **********/
    // Color changing objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    
    // Table
    @IBOutlet weak var levelsTable: UITableView!
    
    // Reference to data
    var modelController:ModelController = ModelController()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set delegates.
        levelsTable.delegate = self
        levelsTable.dataSource = self
        
        // Update the color scheme.
        updateColors()
    }
    
    func updateColors() {
        background.backgroundColor = modelController.getColorBackground(color: modelController.myColor, opacity: 1.0)
        header.backgroundColor = modelController.getColorLight(color: modelController.myColor, opacity: 0.8)
        levelsTable.separatorColor = modelController.getColorLight(color: modelController.myColor, opacity: 1.0)
        // cells are updated in tableView below
    }
    
    // Sets the number of rows to the number of levels.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // When I tried this without the +1 it cut out the last level. It doesn't do this with other tables, like the literary devices table. I have no idea why this works, but for now I will keep it.
        return modelController.getReadingLevel().count + 1
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    // When user clicks the back button, it send them to the StudentLogin scene
    @IBAction func backButton(_ sender: Any) {
        // Go to StudentLogin
        self.performSegue(withIdentifier: "StudentLogin", sender: self)
    }
    
    // If a cell is selected, go to the ... scene.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected cell row to myLevel
        modelController.updateLevel(newLevel: indexPath.row)
        
        // Go to the StudentBooks scene.
        self.performSegue(withIdentifier: "StudentBooks", sender: self)
    }

    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in StudentLogin
        if segue.destination is StudentLoginViewController {
            let Destination = segue.destination as? StudentLoginViewController
            Destination?.modelController = modelController
        }
        
        // Update the modelController in StudentBooks
        if segue.destination is StudentBooksViewController {
            let Destination = segue.destination as? StudentBooksViewController
            Destination?.modelController = modelController
        }
    }
}
