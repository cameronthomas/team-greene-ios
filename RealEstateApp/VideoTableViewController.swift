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
    var videoData: [Dictionary<String, String>] = []
    var activityIndicator = UIActivityIndicatorView()
    var VIDEO_COUNT = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if videoData.isEmpty {
            createActivityIndicator()
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
    }
    
    func createActivityIndicator() {
        activityIndicator.transform = CGAffineTransform(scaleX: 3.75, y: 3.75)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // print(indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
        
//        print(indexPath.section)
//        if !videoData.isEmpty {
            cell.delegate = self
            cell.cellNumber = indexPath.section
        //            cell.videoLabel.text = String(videoData[indexPath.section]["name"]!)
//        }
        
        return cell
    }
    
    func playVideo(cellNumber: Int) {
        print(cellNumber)
        if !videoData.isEmpty {
            let videoURL = URL(string: videoData[cellNumber]["url"]!)
            
            //let temp = "http://embed.wistia.com/deliveries/ed792aefeff85f66a68bca6e0050eb83d212e4a4.bin"
            //  let videoURL = URL(string: temp)
            
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
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
