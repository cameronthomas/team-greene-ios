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
            let downloadDeleteButtonText = (videoSingleton.videoData[indexPath.section][Strings.sharedInstance.isDownloadedKey]! == Strings.sharedInstance.trueValue) ? Strings.sharedInstance.deletebuttonText : Strings.sharedInstance.downloadbuttonText
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
//                print(videoURL)
                
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
}
