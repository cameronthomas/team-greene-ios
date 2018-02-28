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
    func displayExpireError()
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
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        let expirationDate: Date? = dateFormatterGet.date(from: Strings.sharedInstance.courseExpirationDate)
        
        // Don't allow download if course is expired
        if expirationDate! <= Date() {
            delegate?.displayExpireError()
            return
        }
        
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)[0] as NSString)
        if sender.titleLabel?.text == Strings.sharedInstance.downloadbuttonText {

            // Disable button
            self.downloadDeleteButton.isEnabled = false
            sender.setTitle(Strings.sharedInstance.downloadingButtonText, for: .normal)

            // Download video async
            let urlString = URL(string: videoSingleton.videoData[self.cellNumber][Strings.sharedInstance.urlKey]!)
            
            let task = URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
                if error != nil {
                    print(error ?? "Problem with error in creating URL for video metadata")
                } else {
                    
                    self.fileManager.createFile(atPath: path.appendingPathComponent(self.hashedId + "." + Strings.sharedInstance.videoFileType), contents: data, attributes: nil)
                    
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
                    
                    self.videoSingleton.videoData[self.cellNumber][Strings.sharedInstance.localUrlKey] = self.hashedId + "." + Strings.sharedInstance.videoFileType
                    self.videoSingleton.videoData[self.cellNumber][Strings.sharedInstance.isDownloadedKey] = Strings.sharedInstance.trueValue
    
                    VideoDataSingleton.sharedInstance.videoData[self.cellNumber][Strings.sharedInstance.localUrlKey] = self.hashedId + "." + Strings.sharedInstance.videoFileType
                    VideoDataSingleton.sharedInstance.videoData[self.cellNumber][Strings.sharedInstance.isDownloadedKey] = Strings.sharedInstance.trueValue
                    
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
            
            // Delete from documents
            do {
                try fileManager.removeItem(atPath: path.appendingPathComponent(self.hashedId + "." + Strings.sharedInstance.videoFileType))
                
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
            
            // Change button title
            sender.setTitle(Strings.sharedInstance.downloadbuttonText, for: .normal)
            
            // Enable button
            self.downloadDeleteButton.isEnabled = true
        }
    }
    
    
    func downloadVideo() {
        
    }
    
    func deleteVideo() {
        let documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)[0] as NSString)
        
        print(documentsPath.description)
        // Delete from documents
        do {
            try fileManager.removeItem(atPath: documentsPath.appendingPathComponent(self.hashedId + "." + Strings.sharedInstance.videoFileType + "4"))
        }
        catch {
            print(error)
        }
        
        print()
        print()
        
        
//        let documentsURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        do {
//
//            let fileURLs = try self.fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//
//            print("Docs directory after remove:")
//            print(fileURLs)
//            print()
//            // process files
//        } catch {
//            print("Error while enumerating files \(documentsURL): \(error.localizedDescription)")
//        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatterGet.timeZone = TimeZone.current
            let expirationDate: Date? = dateFormatterGet.date(from: Strings.sharedInstance.courseExpirationDate)
            
            if delegate != nil {
                // Videos have not expired
                if expirationDate! > Date() {
                    delegate?.playVideo(cellNumber: cellNumber)
                }
                    
                // Vieos have expired
                else {
                    delegate?.displayExpireError()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
