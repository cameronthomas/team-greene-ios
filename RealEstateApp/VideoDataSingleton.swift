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
    private init() { }
    var videoDataRecieved:Data? = nil
    
    let filePath =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(Strings.sharedInstance.videoDataFilename)
    
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
                    for (index, videoObject) in videoList.enumerated() {
                        var tempDictionary = [String: String]()
                        
                        if let videoElements = videoObject as? [String: Any] {
                            tempDictionary[Strings.sharedInstance.nameKey] = videoElements[Strings.sharedInstance.nameKey]! as? String
                            tempDictionary[Strings.sharedInstance.hashedIdKey] = videoElements[Strings.sharedInstance.hashedIdKey]! as? String
                            
                            // Check to see if hash id exists as a file
                            // If it does exist then set isDownload to true and set local URL to value
                            
                            // if it does not exist then set isDownloaded to false and set local URL to "none"
                            tempDictionary[Strings.sharedInstance.isDownloadedKey] = Strings.sharedInstance.falseValue
                            tempDictionary[Strings.sharedInstance.localUrlKey] = Strings.sharedInstance.localUrlEmptyValue

                            // Replace line below with array returned from google sheet
                            tempDictionary[Strings.sharedInstance.activeDateKey] = Strings.sharedInstance.videoActiveDates[index]
                            
                            if let assets = videoElements[Strings.sharedInstance.apiAssetsKey]! as? [Any] {
                                if let videoDictionary = assets[1] as? [String: Any] {
                                    tempDictionary[Strings.sharedInstance.urlKey] = videoDictionary[Strings.sharedInstance.apiUrlKey]! as? String
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
