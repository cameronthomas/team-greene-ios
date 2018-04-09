//
//  VideoTableViewController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 10/30/17.
//  Copyright © 2017 Cameron Thomas and Team Green Real Estate. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoTableViewController: UITableViewController, playVideoDelegate  {
    // Properties
    var videoSingleton:VideoDataSingleton = VideoDataSingleton.sharedInstance
    var activityIndicator = UIActivityIndicatorView()
    let playerViewController = AVPlayerViewController()
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicator()
    }
    
    /**
     * Load data into table
     */
    func loadDataInView() {
        print("loadDataInView")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        
        guard let expirationDate: Date = dateFormatterGet.date(from: Strings.sharedInstance.courseExpirationDate) else {
            ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error getting expiration date: loadDataInView()")
            ErrorHandling.sharedInstance.displayUIErrorMessage(sender: self)
            self.view.isUserInteractionEnabled = false
            return
        }
        
        expirationDate <= Date() ? displayExpireError() : tableView.reloadData() // Display error and disable videos if course is expired
    }
    
    /**
     * Create load indicator
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
     * Run for creation of each cell
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.sharedInstance.VideoCellIdentifier, for: indexPath) as! VideoTableViewCell
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        
        if !videoSingleton.videoData.isEmpty {
            cell.videoTableDelegate = self
            cell.cellNumber = indexPath.section
            
            // Initialize function constants and check for errors
            guard let videoLabel = videoSingleton.videoData[indexPath.section][Strings.sharedInstance.nameKey],
                let hashedId = videoSingleton.videoData[indexPath.section][Strings.sharedInstance.hashedIdKey],
                let isDownloaded = videoSingleton.videoData[indexPath.section][Strings.sharedInstance.isDownloadedKey],
                let activeDate: Date = dateFormatterGet.date(from: Strings.sharedInstance.videoActiveDates[indexPath.section]),
                let expirationDate: Date = dateFormatterGet.date(from: Strings.sharedInstance.courseExpirationDate)
                else {
                    ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error pulling values out of videoSingleton: tableView()")
                    ErrorHandling.sharedInstance.displayUIErrorMessage(sender: self)
                    self.view.isUserInteractionEnabled = false
                    return cell
            }
            
            let downloadDeleteButtonText = (isDownloaded == Strings.sharedInstance.trueValue) ? Strings.sharedInstance.deletebuttonText : Strings.sharedInstance.downloadbuttonText
            
            cell.videoLabel.text = videoLabel
            cell.hashedId = hashedId
            cell.downloadDeleteButton.setTitle(downloadDeleteButtonText, for: .normal)
            
            // Set cell usability based on active and expiration dates
            activeDate >= Date() || expirationDate <= Date() ? changeCellUsability(cell: cell, enableCell: false) : changeCellUsability(cell: cell, enableCell: true)
            
            // If we are at the last element, then the list is done loading
            // Stop activity indicator
            if indexPath.section == videoSingleton.videoData.count - 1 {
                activityIndicator.stopAnimating()
            }
        }
        
        return cell
    }
    
    /**
     * Play videos
     */
    func playVideo(cellNumber: Int) {
        if !videoSingleton.videoData.isEmpty {
            // Initialize function constants and check for errors
            guard let isDownloaded = videoSingleton.videoData[cellNumber][Strings.sharedInstance.isDownloadedKey],
                let localUrl = videoSingleton.videoData[cellNumber][Strings.sharedInstance.localUrlKey],
                let remoteUrl = videoSingleton.videoData[cellNumber][Strings.sharedInstance.urlKey],
                let videoURL = isDownloaded == Strings.sharedInstance.trueValue ? URL(fileURLWithPath: Strings.sharedInstance.documentsPath.appendingPathComponent(localUrl)) :
                    URL(string: remoteUrl) // Get local url if downloaded, get remote url otherwise.
                else {
                    ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error initializing values: playVideo()")
                    ErrorHandling.sharedInstance.displayUIErrorMessage(sender: self)
                    self.view.isUserInteractionEnabled = false
                    return
            }
 
            print(AVFoundation.AVVideoCodecH264)
            
            // Prepare for and play video
            let asset = AVURLAsset(url: videoURL, options: nil)
            

            
            
            let assetKeys = [
                "playable",
                "hasProtectedContent"
            ]
            
         //   var playerItemContext = 0
            
            
            let avPlayerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
           // avPlayerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new], context: &playerItemContext)
            
            let player = AVPlayer(playerItem: avPlayerItem)
            
            playerViewController.player = player
            
            //            self.observe = avPlayerItem.observe("status", options: [.new], changeHandler: { (playerItem, change) in
            //                if playerItem.status == .readyToPlay {
            //                    print("asdf")
            //                }
            //            })
            
         //   print(playerViewController.isReadyForDisplay)
         //   playerViewController.addObserver(self, forKeyPath: #keyPath(AVPlayerViewController.isReadyForDisplay), options: [.new], context: nil)
            
            
            
            self.present(playerViewController, animated: true) {
                player.play()
                //  playerViewController.player?.play()
            }
            

        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(AVPlayerViewController.isReadyForDisplay) {
            if (object as! AVPlayerViewController).isReadyForDisplay == true {
                print("ready:", self.playerViewController.isReadyForDisplay)
                self.present(self.playerViewController, animated: true) {
                    //player.play()
                    self.playerViewController.player?.play()
                }
            }
        }
       // self.playerViewController.removeObserver(self, forKeyPath: #keyPath(AVPlayerViewController.isReadyForDisplay))
        
        //        if keyPath == #keyPath(AVPlayerItem.status) {
//            let status: AVPlayerItemStatus
//
//            // Get the status change from the change dictionary
//            if let statusNumber = change?[.newKey] as? NSNumber {
//                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
//            } else {
//                status = .unknown
//            }
//
//            // Switch over the status
//            switch status {
//            case .readyToPlay:
//                print("ready to play")
//                self.present(playerViewController, animated: true) {
//                    self.playerViewController.player?.play()
//                }
//            case .failed:
//                print("failed")
//            case .unknown:
//                print("Unknown")
//            }
//        }
//
//
        
        
        
        
        
        
        
        //        let temp = object as! AVPlayerItem
        //        print("status:", temp.status.rawValue)
        //
        //
        //
        //        if temp.status.rawValue == 1 {
        //            print("observer")
        //            self.present(playerViewController, animated: true) {
        //                //  player.play()
        //                self.playerViewController.player?.play()
        //            }
        //        }
    }
    
    
    /**
     * Display error message when course has expired
     */
    func displayExpireError() {
        let alert = UIAlertController(title: "Error", message: "The course has ended and all videos have expired.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: videosExpiredHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     * Take necesary actions when course has expired
     */
    func videosExpiredHandler(alert: UIAlertAction!) {
        print("videosExpiredHandler")
        
        // Delete all video downloads
        for cell in tableView.visibleCells {
            let cellObject = cell as! VideoTableViewCell
            if videoSingleton.videoData[cellObject.cellNumber][Strings.sharedInstance.isDownloadedKey] == Strings.sharedInstance.trueValue {
                cellObject.deleteVideo()
            }
            
            // Update video data list in memory
            videoSingleton.videoData[cellObject.cellNumber][Strings.sharedInstance.localUrlKey] = Strings.sharedInstance.localUrlEmptyValue
            videoSingleton.videoData[cellObject.cellNumber][Strings.sharedInstance.isDownloadedKey] = Strings.sharedInstance.falseValue
        }
        
        tableView.reloadData()
    }
    
    /**
     * Toggle whether cell is enabled
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
        return videoSingleton.videoData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
}
