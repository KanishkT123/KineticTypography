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
    
    // Video variables.
    var videoTitles:[String] = []
    
    // UserDefaults variables.
    var data:Data = Data()
    var library:Library = Library()
    
    
    /********** VIEW FUNCTIONS **********/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get UserDefaults values.
        library = Library(dictionary: UserDefaults.standard.dictionary(forKey: "library")!)
        
        // Set delegates.
        videosTable.delegate = self
        videosTable.dataSource = self
        
        // Get video titles.
        for video:Video in library.videos {
            // Add each video title to videoTitles
            let videoTitle:String = "\(video.name) - \(video.bookTitle)"
            videoTitles.append(videoTitle)
        }
    }
    
    // Sets the number of rows to the number of saved videos.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return library.videos.count
    }
    
    // Configures each cell by row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Accesses the current row
        let Cell:UITableViewCell = videosTable.dequeueReusableCell(withIdentifier: "Video")!
        
        // Gets saved video title
        let videoTitle = videoTitles[indexPath.row]
        let title = videoTitle
        
        // Inputs and centers (supposedly) the title and subtitle
        Cell.textLabel?.text = title
        Cell.textLabel?.textAlignment = .center
        
        return Cell
    }
    
    
    /********** SEGUE FUNCTIONS **********/
    // When user clicks the back button, it send them to the TeacherWelcome scene
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "TeacherWelcome", sender: self)
    }
    
    // If a cell is selected, go to the VideoDetails scene.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected cell row to myVideo.
        data.myVideo = indexPath.row
        
        // Go to the VideoDetails scene.
        self.performSegue(withIdentifier: "VideoDetails", sender: self)
    }

    // Passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the data in TeacherWelcome
        if segue.destination is TeacherWelcomeViewController {
            let Destination = segue.destination as? TeacherWelcomeViewController
            Destination?.data = data
        }

        // Update the data in VideoDetails
        if segue.destination is VideoDetailsViewController {
            let Destination = segue.destination as? VideoDetailsViewController
            Destination?.data = data
        }
    }
}
