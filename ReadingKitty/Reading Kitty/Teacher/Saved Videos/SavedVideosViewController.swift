//
//  SavedVideosViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/8/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class SavedVideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /********** LOCAL VARIABLES **********/
    // Table
    @IBOutlet weak var videosTable: UITableView!
    
    // Reference to levels, books, and devices
    var modelController:ModelController = ModelController()
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //modelController = UserDefaults.standard.object(forKey: "modelController") as! ModelController
        videosTable.delegate = self
        videosTable.dataSource = self
    }
    
    // Sets the number of rows to the number of saved videos.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.savedVideos.count
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Accesses the current row
        let Cell:UITableViewCell = videosTable.dequeueReusableCell(withIdentifier: "Video")!
        
        // Gets saved video title
        let videoTitle = modelController.getVideoTitles()[indexPath.row]
        let title = videoTitle
        
        // Inputs and centers (supposedly) the title and subtitle
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        return Cell
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the TeacherWelcome scene
    @IBAction func backButton(_ sender: Any) {
        // Go to TeacherWelcome
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    
    // If a cell is selected, go to the VideoDetails scene.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected cell row to myVideo.
        modelController.updateVideo(newVideo: indexPath.row)
        
        // Go to the VideoDetails scene.
        self.performSegue(withIdentifier: "VideoDetails", sender: self)
    }

    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //UserDefaults.standard.set(modelController, forKey: "modelController")
        
        // Update the modelController in TeacherWelcome
        if segue.destination is TeacherWelcomeViewController {
            let Destination = segue.destination as? TeacherWelcomeViewController
            Destination?.modelController = modelController
        }

        // Update the modelController in VideoDetails
        if segue.destination is VideoDetailsViewController {
            let Destination = segue.destination as? VideoDetailsViewController
            Destination?.modelController = modelController
        }
    }
}
