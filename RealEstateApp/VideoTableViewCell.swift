//
//  VideoTableViewCell.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 11/12/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit
import AVKit

protocol playVideoDelegate: NSObjectProtocol {
    func playVideo(cellNumber: Int)
}

class VideoTableViewCell: UITableViewCell
{
    var cellNumber = -1
    weak var delegate: playVideoDelegate? = nil
    var activityIndicator = UIActivityIndicatorView()
    var videoSingleton:VideoDataSingleton = VideoDataSingleton.sharedInstance
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var downloadDeleteButton: UIButton!
    var hashedId = ""
    let fileManager = FileManager.default
    
    
    @IBAction func downloadDeleteButtonAction(_ sender: UIButton) {
        
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)[0] as NSString).appendingPathComponent(self.hashedId + ".mp4")
        if sender.titleLabel?.text == "Download" {
            
            // Disable button
            DispatchQueue.main.async {
                self.downloadDeleteButton.isEnabled = false
            }
            
            // Display spinner to right of button
            // TODO
            
            // Download video async
            let urlString = URL(string: videoSingleton.videoData[self.cellNumber]["url"]!)
            
            let task = URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
                if error != nil {
                    print(error ?? "Problem with error in creating URL for video metadata")
                } else {
                    
                    
                    self.fileManager.createFile(atPath: path as String, contents: data, attributes: nil)
                    
                    let documentsURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    
                    do {
                        let fileURLs = try self.fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                        
                        print("Docs directory after add:")
                        print(fileURLs)
                        print()
                        // process files
                    } catch {
                        print("Error while enumerating files \(documentsURL): \(error.localizedDescription)")
                    }
                    
                    
                    self.videoSingleton.videoData[self.cellNumber]["localURL"] = path
                    self.videoSingleton.videoData[self.cellNumber]["isDownloaded"] = "true"
    
                    VideoDataSingleton.sharedInstance.videoData[self.cellNumber]["localURL"] = path
                    VideoDataSingleton.sharedInstance.videoData[self.cellNumber]["isDownloaded"] = "true"
                    
                    
                    // Add video to documents
                    DispatchQueue.main.async {
                        // Refresh view
                        // MIGHT NOT NEED BELOW
                        // Update UI
                        // Change button title
                        sender.setTitle("Delete Download", for: .normal)
                        
                        // Enable button
                        self.downloadDeleteButton.isEnabled = true
                        // Turn off and get rid of spinner
                        
                    }
                }
            }
            task.resume()
            print("after")
        } else {

            // Disable button
                self.downloadDeleteButton.isEnabled = false
            
            // Display spinner to right of button
            
            // Update Video data list (NEED TO ACCESS VideoTableViewController)
            self.videoSingleton.videoData[self.cellNumber]["localURL"] = ""
            self.videoSingleton.videoData[self.cellNumber]["isDownloaded"] = "false"
            
            // Delete from docs
            do {
                try fileManager.removeItem(atPath: path)
                
                let documentsURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                do {
                    
                    let fileURLs = try self.fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                    
                    print("Docs directory after remove:")
                    print(fileURLs)
                    print()
                    // process files
                } catch {
                    print("Error while enumerating files \(documentsURL): \(error.localizedDescription)")
                }
            }
            catch {
                print("Could not clear temp folder: \(error)")
            }
            
            // Update UI
            // Change button title
            
            // Enable button
            // Add video to documents
            // MIGHT NOT NEED BELOW
            // Update UI
            // Change button title
            sender.setTitle("Download", for: .normal)
            
            // Enable button
            self.downloadDeleteButton.isEnabled = true
            // Turn off and get rid of spinner
            
            
            // Turn off and get rid of spinner
        }
    }
    
    
    func downloadVideo() {
        
    }
    
    func deleteVideo() {
        
    }
    
    func createActivityIndicator() {
     //   activityIndicator.transform = CGAffineTransform(scaleX: 3.75, y: 3.75)
        activityIndicator.contentMode = .scaleAspectFit
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        activityIndicator.center = self.accessoryView?.center
        activityIndicator.hidesWhenStopped = true
        self.accessoryView = activityIndicator as UIView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            if delegate != nil {
                delegate?.playVideo(cellNumber: cellNumber)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
