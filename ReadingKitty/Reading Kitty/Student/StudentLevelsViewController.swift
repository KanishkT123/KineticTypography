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
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values.
        myColor = UserDefaults.standard.object(forKey: "myColor") as! Int
        readingLevels = UserDefaults.standard.object(forKey: "readingLevels") as! [String]
        
        // Set delegates.
        levelsTable.delegate = self
        levelsTable.dataSource = self
        
        // Update the color scheme.
        updateColors()
    }
    
    // Update the color scheme based on what color the user chose at the login.
    func updateColors() {
        background.backgroundColor = getColorBackground(color: myColor, opacity: 1.0)
        header.backgroundColor = getColorLight(color: myColor, opacity: 0.8)
        levelsTable.separatorColor = getColorLight(color: myColor, opacity: 1.0)
        // The cells are updated in tableView function below.
    }
    
    // Sets the number of rows to the number of levels.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingLevels.count
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Accesses the current row
        let Cell:UITableViewCell = levelsTable.dequeueReusableCell(withIdentifier: "Level")!
        
        // Gets reading title
        let readingLevel = readingLevels[indexPath.row]
        let title = readingLevel
        
        // Inputs and centers (supposedly) the title and subtitle
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        // Update colors
        var textColor:UIColor = getColorLight(color: myColor, opacity: 1.0)
        if myColor == 2 {
            textColor = UIColor.black
        }
        Cell.backgroundColor = getColorDark(color: myColor, opacity: 0.8)
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
        UserDefaults.standard.set(indexPath.row, forKey: "myLevel")
        
        // Go to the StudentBooks scene.
        self.performSegue(withIdentifier: "StudentBooks", sender: self)
    }

//    // Passing data
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //UserDefaults.standard.set(modelController, forKey: "modelController")
//
//        // Update the modelController in StudentLogin
//        if segue.destination is StudentLoginViewController {
//            let Destination = segue.destination as? StudentLoginViewController
//            Destination?.modelController = modelController
//        }
//
//        // Update the modelController in StudentBooks
//        if segue.destination is StudentBooksViewController {
//            let Destination = segue.destination as? StudentBooksViewController
//            Destination?.modelController = modelController
//        }
//    }
}
