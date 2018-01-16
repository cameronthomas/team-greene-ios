//
//  VideoData.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 1/15/18.
//  Copyright © 2018 Cameron Thomas. All rights reserved.
//

import Foundation

class VideoDataSingleton {
    static let sharedInstance = VideoDataSingleton()
    var videoDataRecieved:Data? = nil
    
    let filePath =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("data.plist")
    
    var videoData: [Dictionary<String, String>] {
        
        get {
            return NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as? [Dictionary<String, String>] ?? []
        }
        set {
            NSKeyedArchiver.archiveRootObject(newValue, toFile: filePath.path)
        }
    }
    
    func processData() {
        if videoData.isEmpty {
            print("new data fetched")
            if let usableData = videoDataRecieved {
                let json = try? JSONSerialization.jsonObject(with: usableData)
                if let videoList = json as? [Any] {
                    for videoObject in videoList {
                        var tempDictionary = [String: String]()
                        
                        if let videoElements = videoObject as? [String: Any] {
                            tempDictionary["name"] = videoElements["name"]! as? String
                            tempDictionary["hashed_id"] = videoElements["hashed_id"]! as? String
                            
                            // Check to see if hash id exists as a file
                            // If it does exist then set isDownload to true and set local URL to value
                            
                            // if it does not exist then set isDownloaded to false and set local URL to "none"
                            tempDictionary["isDownloaded"] = "false"
                            
                            
                            tempDictionary["localURL"] = "none"
                            
                            if let assets = videoElements["assets"]! as? [Any] {
                                if let videoDictionary = assets[1] as? [String: Any] {
                                    tempDictionary["url"] = videoDictionary["url"]! as? String
                                    self.videoData.append(tempDictionary)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
