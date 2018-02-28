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
    // Properties
    var videoSingleton:VideoDataSingleton = VideoDataSingleton.sharedInstance
    var videoDataRecieved:Data? = nil
    var activityIndicator = UIActivityIndicatorView()
    var VIDEO_COUNT = 0
    let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                    .userDomainMask, true)[0] as NSString)
    
    /**
     View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicator()
    }
    
    /**
     Load data into table
     */
    func loadDataInView() {
        print("loadDataInView")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        let expirationDate: Date? = dateFormatterGet.date(from: Strings.sharedInstance.courseExpirationDate)
        
        VIDEO_COUNT = videoSingleton.videoData.count
        
        if expirationDate! <= Date() {
            displayExpireError()
        } else {
            tableView.reloadData()
        }
    }
    
    /**
     Create load indicator
     */
    func createActivityIndicator() {
        activityIndicator.transform = CGAffineTransform(scaleX: 3.75, y: 3.75)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    /**
     Run for creation of each cell
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.sharedInstance.VideoCellIdentifier, for: indexPath) as! VideoTableViewCell
        
        if !videoSingleton.videoData.isEmpty {
            cell.delegate = self
            cell.cellNumber = indexPath.section
            cell.videoLabel.text = String(videoSingleton.videoData[indexPath.section][Strings.sharedInstance.nameKey]!)
            cell.hashedId = String(videoSingleton.videoData[indexPath.section][Strings.sharedInstance.hashedIdKey]!)
            print(videoSingleton.videoData[indexPath.section][Strings.sharedInstance.isDownloadedKey]!)
            print(videoSingleton.videoData[indexPath.section][Strings.sharedInstance.localUrlKey]!)
            var downloadDeleteButtonText = (videoSingleton.videoData[indexPath.section][Strings.sharedInstance.isDownloadedKey]! == Strings.sharedInstance.trueValue) ? Strings.sharedInstance.deletebuttonText : Strings.sharedInstance.downloadbuttonText
            cell.downloadDeleteButton.setTitle(downloadDeleteButtonText, for: .normal)
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatterGet.timeZone = TimeZone.current
            
            let activeDate: Date? = dateFormatterGet.date(from: videoSingleton.videoData[indexPath.section][Strings.sharedInstance.activeDateKey]!)
            let expirationDate: Date? = dateFormatterGet.date(from: Strings.sharedInstance.courseExpirationDate)
            
            if (activeDate! >= Date() || expirationDate! <= Date()) {
               changeCellUsability(cell: cell, enableCell: false)
            }
            else {
                changeCellUsability(cell: cell, enableCell: true)
            }
        }
        
        print("inside cell function")

        // If we are at the last element, then the list is done loading
        // Stop activity indicator
        if indexPath.section == videoSingleton.videoData.count - 1 {
            print("list done loading")
            activityIndicator.stopAnimating()
        }
        
        return cell
    }
    
    /**
     Play videos
     */
    func playVideo(cellNumber: Int) {
        var videoURL:URL?
        var player:AVPlayer
        
        if !videoSingleton.videoData.isEmpty {
            if videoSingleton.videoData[cellNumber][Strings.sharedInstance.isDownloadedKey]! == Strings.sharedInstance.trueValue {
                videoURL = URL(fileURLWithPath: path.appendingPathComponent(videoSingleton.videoData[cellNumber][Strings.sharedInstance.localUrlKey]!))
                print(videoURL)
                
            } else {
                videoURL = URL(string: videoSingleton.videoData[cellNumber][Strings.sharedInstance.urlKey]!)
            }
            
            player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    /**
     Display error message when course has expired
     */
    func displayExpireError() {
        let alert = UIAlertController(title: "Error", message: "The course has ended and all videos have expired.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: videosExpiredHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Take necesary actions when course has expired
     */
    func videosExpiredHandler(alert: UIAlertAction!) {
        print("videosExpiredHandler")
        
        for cell in tableView.visibleCells {
            let cellObject = cell as! VideoTableViewCell
            if videoSingleton.videoData[cellObject.cellNumber][Strings.sharedInstance.isDownloadedKey] == Strings.sharedInstance.trueValue {
                cellObject.deleteVideo()
            }
            
            videoSingleton.videoData[cellObject.cellNumber][Strings.sharedInstance.localUrlKey] = Strings.sharedInstance.localUrlEmptyValue
            videoSingleton.videoData[cellObject.cellNumber][Strings.sharedInstance.isDownloadedKey] = Strings.sharedInstance.falseValue
        }
        
        tableView.reloadData()
    }
    
    /**
     Toggle whether cell is enabled
     */
    func changeCellUsability(cell: VideoTableViewCell, enableCell: Bool) {
        if (enableCell) {
            cell.isUserInteractionEnabled = true
            cell.videoLabel.alpha = 1
            cell.downloadDeleteButton.alpha = 1
        }
        else {
            cell.isUserInteractionEnabled = false
            cell.videoLabel.alpha = 0.2
            cell.downloadDeleteButton.alpha = 0.2
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return VIDEO_COUNT
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func videoDownloadCode() {
        
//        let fileManager = FileManager.default
//        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
//                                                        .userDomainMask, true)[0] as NSString).appendingPathComponent("vid.mp4")
//
//
//        let urlString = "http://embed.wistia.com/deliveries/7f262905ddc81d95c62e025cc9a0d653251c1fc8.bin"
//        let url = URL(string: urlString)
//        let video = NSData(contentsOf: url!)
//
//        fileManager.createFile(atPath: path as String, contents: video as! Data, attributes: nil)
//
//        print("this is the path:", path)
//
//
//
//        let videoURL = URL(fileURLWithPath: path)
//        let player = AVPlayer(url: videoURL)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
        
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
