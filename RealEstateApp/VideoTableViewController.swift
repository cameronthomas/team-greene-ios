//
//  VideoTableViewController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 10/30/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit
import AVKit

class VideoTableViewController: UITableViewController, playVideoDelegate  {    
    var videoSingleton:VideoDataSingleton = VideoDataSingleton.sharedInstance
    var videoDataRecieved:Data? = nil
    var activityIndicator = UIActivityIndicatorView()
    var VIDEO_COUNT = 0
    let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                    .userDomainMask, true)[0] as NSString)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        createActivityIndicator()
        activityIndicator.startAnimating()
    }
    
    func loadDataInView() {
      //  videoSingleton = VideoDataSingleton.sharedInstance
        VIDEO_COUNT = videoSingleton.videoData.count
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    func createActivityIndicator() {
        activityIndicator.transform = CGAffineTransform(scaleX: 3.75, y: 3.75)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
        
        if !videoSingleton.videoData.isEmpty {
            cell.delegate = self
            cell.cellNumber = indexPath.section
            cell.videoLabel.text = String(videoSingleton.videoData[indexPath.section]["name"]!)
            cell.hashedId = String(videoSingleton.videoData[indexPath.section]["hashed_id"]!)
            print(videoSingleton.videoData[indexPath.section]["isDownloaded"]!)
            print(videoSingleton.videoData[indexPath.section]["localURL"]!)
            var downloadDeleteButtonText = (videoSingleton.videoData[indexPath.section]["isDownloaded"]! == "true") ? "Delete Download" : "Download"
            cell.downloadDeleteButton.setTitle(downloadDeleteButtonText, for: .normal)
        }
        
        return cell
    }
    
    func playVideo(cellNumber: Int) {
        var videoURL:URL?
        var player:AVPlayer
        
        if !videoSingleton.videoData.isEmpty {
            
            // Check to see if video is downloaded
                // If video is downloaded then set to local URL
            
                // If video is not dowloaded then set to remote URL

            if videoSingleton.videoData[cellNumber]["isDownloaded"]! == "true" {
                videoURL = URL(fileURLWithPath: path.appendingPathComponent( videoSingleton.videoData[cellNumber]["localURL"]!))
                print(videoURL)
                
            } else {
                videoURL = URL(string: videoSingleton.videoData[cellNumber]["url"]!)
            }
            
            player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    func videoDownloadCode() {
        
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)[0] as NSString).appendingPathComponent("vid.mp4")
       
        
        let urlString = "http://embed.wistia.com/deliveries/7f262905ddc81d95c62e025cc9a0d653251c1fc8.bin"
        let url = URL(string: urlString)
        let video = NSData(contentsOf: url!)
        
        fileManager.createFile(atPath: path as String, contents: video as! Data, attributes: nil)
        
        print("this is the path:", path)
        
        
        
        let videoURL = URL(fileURLWithPath: path)
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return VIDEO_COUNT

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    

    
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
}
