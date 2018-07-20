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
    // Color scheme objects
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    
    // Table
    @IBOutlet weak var levelsTable: UITableView!
    
    // UserDefaults variables.
    var myColor:Int = 0
    var readingLevels:[String] = []
    
    var data:Data = Data()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set delegates.
        levelsTable.delegate = self
        levelsTable.dataSource = self
        
        // Update the color scheme.
        updateColors()
    }
    
    // Update the color scheme based on what color the user chose at the login.
    func updateColors() {
        let colorScheme:Color = data.colors[data.myColor]
        background.backgroundColor = colorScheme.getColorBackground(opacity: 1.0)
        header.backgroundColor = colorScheme.getColorLight(opacity: 0.8)
        levelsTable.separatorColor = colorScheme.getColorLight(opacity: 1.0)
        // The cells are updated in tableView function below.
    }
    
    // Sets the number of rows to the number of levels.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.readingLevels.count
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Accesses the current row
        let Cell:UITableViewCell = levelsTable.dequeueReusableCell(withIdentifier: "Level")!
        
        // Gets reading title
        let readingLevel = data.readingLevels[indexPath.row]
        let title = readingLevel
        
        // Inputs and centers (supposedly) the title and subtitle
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        // Update colors
        let colorScheme:Color = data.colors[data.myColor]
        var textColor:UIColor = colorScheme.getColorLight(opacity: 1.0)
        if data.myColor == 2 {
            textColor = UIColor.black
        }
        Cell.backgroundColor = colorScheme.getColorDark(opacity: 0.8)
        Cell.textLabel?.textColor = textColor
        
        return Cell
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the StudentLogin scene
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "StudentLogin", sender: self)
    }
    
    // If a cell is selected, go to the ... scene.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected cell row to myLevel
        data.myLevel = indexPath.row
        
        // Go to the StudentBooks scene.
        self.performSegue(withIdentifier: "StudentBooks", sender: self)
    }

    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in StudentLogin
        if segue.destination is StudentLoginViewController {
            let Destination = segue.destination as? StudentLoginViewController
            Destination?.data = data
        }

        // Update the data in StudentBooks
        if segue.destination is StudentBooksViewController {
            let Destination = segue.destination as? StudentBooksViewController
            Destination?.data = data
        }
    }
}
