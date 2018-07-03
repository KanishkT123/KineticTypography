//
//  SavedVideosTableViewController.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/13/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class SavedVideosTableViewController: UITableViewController {
    /********** LOCAL VARIABLES **********/
    // TableView
    @IBOutlet var videosTable: UITableView!
    
    // Reference to levels, books, and devices
    var modelController = ModelController()
    
    
    /********** VIEW FUNCTIONS **********/
    // Gives access to editing the table.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videosTable.delegate = self
        videosTable.dataSource = self
    }
    
    // Sets the number of rows to the number of saved videos.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.savedVideos.count
    }
    
    // Configures each cell by row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    // If a cell is selected, go to VideoDetails.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected cell row to myVideo
        modelController.updateVideo(newVideo: indexPath.row)
        
        // Go to SavedVideos
        print("going to saved videos")
        self.performSegue(withIdentifier: "SavedVideos", sender: self)
    }
    
    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the modelController in SavedVideos
        if segue.destination is SavedVideosViewController {
            let Destination = segue.destination as? SavedVideosViewController
            Destination?.modelController = modelController
            Destination?.tableSelected = true
        }
    }
}
