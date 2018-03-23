//
//  VideoTableViewCell.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 11/12/17.
//  Copyright © 2017 Cameron Thomas and Team Green Real Estate. All rights reserved.
//

import UIKit
import AVKit

protocol playVideoDelegate: NSObjectProtocol {
    func playVideo(cellNumber: Int)
    func displayExpireError()
}

class VideoTableViewCell: UITableViewCell
{
    var cellNumber = -1
    weak var videoTableDelegate: playVideoDelegate? = nil
    var activityIndicator = UIActivityIndicatorView()
    var videoSingleton:VideoDataSingleton = VideoDataSingleton.sharedInstance
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var downloadDeleteButton: UIButton!
    var hashedId = ""
    let fileManager = FileManager.default
    let documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                             .userDomainMask, true)[0] as NSString) // Path to docs dir to save and delete videos
    
    /**
     * Download/Delete Button Action
     */
    @IBAction func downloadDeleteButtonAction(_ sender: UIButton) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        
        guard let delegate = videoTableDelegate else  {
            ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Delegate not set: downloadDeleteButtonAction()")
            return
        }
        
        guard let expirationDate: Date = dateFormatterGet.date(from: Strings.sharedInstance.courseExpirationDate),
            let titleLabel = sender.titleLabel?.text,
            let videoRemoteUrlString = videoSingleton.videoData[self.cellNumber][Strings.sharedInstance.urlKey],
            let videoRemoteUrl = URL(string: videoRemoteUrlString)
            else {
                ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error initializing vars: downloadDeleteButtonAction()")
                ErrorHandling.sharedInstance.displayUIErrorMessage(sender: delegate  as! UIViewController)
                return
        }
        
        // Don't allow download if course is expired
        if expirationDate <= Date() {
            delegate.displayExpireError()
            return
        }
        
        if titleLabel == Strings.sharedInstance.downloadbuttonText {
            // Disable button
            self.downloadDeleteButton.isEnabled = false
            sender.setTitle(Strings.sharedInstance.downloadingButtonText, for: .normal)
            
            // Download video async
            let task = URLSession.shared.dataTask(with: videoRemoteUrl) { (data, response, error) in
                if error != nil {
                    ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error in downloading video: downloadDeleteButtonAction() "
                        + error.debugDescription)
                } else {
                    
                    // Save video file
                    self.fileManager.createFile(atPath: self.documentsPath.appendingPathComponent(self.hashedId + "." + Strings.sharedInstance.videoFileType), contents: data, attributes: nil)
                    
                    // Update videoData list
                    self.videoSingleton.videoData[self.cellNumber][Strings.sharedInstance.localUrlKey] = self.hashedId + "." + Strings.sharedInstance.videoFileType
                    self.videoSingleton.videoData[self.cellNumber][Strings.sharedInstance.isDownloadedKey] = Strings.sharedInstance.trueValue
                    
                    // Update UI
                    DispatchQueue.main.async {
                        // Change button title
                        sender.setTitle(Strings.sharedInstance.deletebuttonText, for: .normal)
                        
                        // Enable button
                        self.downloadDeleteButton.isEnabled = true
                    }
                }
            }
            task.resume()
        } else {
            // Disable button
            self.downloadDeleteButton.isEnabled = false
            
            // Update Video data list (NEED TO ACCESS VideoTableViewController)
            self.videoSingleton.videoData[self.cellNumber][Strings.sharedInstance.localUrlKey] = Strings.sharedInstance.localUrlEmptyValue
            self.videoSingleton.videoData[self.cellNumber][Strings.sharedInstance.isDownloadedKey] = Strings.sharedInstance.falseValue
            
            deleteVideo()
            
            // Change button title
            sender.setTitle(Strings.sharedInstance.downloadbuttonText, for: .normal)
            
            // Enable button
            self.downloadDeleteButton.isEnabled = true
        }
    }
    
    /**
     * Delete Video
     */
    func deleteVideo() {
        // Delete from documents
        do {
            try fileManager.removeItem(atPath: documentsPath.appendingPathComponent(self.hashedId + "." + Strings.sharedInstance.videoFileType))
        }
        catch {
            ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error deleting file:" + error.localizedDescription)
        }
    }
    
    /**
     * Selected cell func
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatterGet.timeZone = TimeZone.current
            
            guard let delegate = videoTableDelegate else {
                ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error delegate not set: setSelected()")
                return
            }
            
            guard let expirationDate: Date = dateFormatterGet.date(from: Strings.sharedInstance.courseExpirationDate)
                else {
                    ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error: setSelected()")
                    ErrorHandling.sharedInstance.displayUIErrorMessage(sender: delegate  as! UIViewController)
                    return
            }
            
            // Check if course is expired
            expirationDate > Date() ? delegate.playVideo(cellNumber: cellNumber) : delegate.displayExpireError()
        }   
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
