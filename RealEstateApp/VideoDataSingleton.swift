//
//  VideoData.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 1/15/18.
//  Copyright © 2018 Cameron Thomas and Team Green Real Estate. All rights reserved.
//

import Foundation
import SwiftyJSON

class VideoDataSingleton {
    static let sharedInstance = VideoDataSingleton()
    private init() { }
    
    // Get file for video data list
    var filePath: URL {
        get {
            do {
                let tempPath = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(Strings.sharedInstance.videoDataFilename)
                return tempPath
                
            } catch {
                ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Problem creating filepath: VideoDataSingleton " + error.localizedDescription)
                return URL(fileURLWithPath: "Error")
            }
        }
    }

    // Define video data list
    var videoData: [Dictionary<String, String>] {

        get {
            guard let videoDataTemp = NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as? [Dictionary<String, String>] else {
                ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Problem reading videoData from memory: ")
                return []
            }
            
            return videoDataTemp
        }
        set {
            // Archive video data list
            NSKeyedArchiver.archiveRootObject(newValue, toFile: filePath.path)
        }
    }
    
    /**
     * Populate Video Data List
     */
    func populateVideoDataList(value: Any) {
        if let videoList = JSON(value).array {
            for (index, videoObject) in videoList.enumerated() {
                var videoDictionary = [String: String]()
                
                if let videoElements = videoObject.dictionary {
                    // Save name and hased id
                    videoDictionary[Strings.sharedInstance.nameKey] = videoElements[Strings.sharedInstance.nameKey]?.stringValue
                    videoDictionary[Strings.sharedInstance.hashedIdKey] = videoElements[Strings.sharedInstance.hashedIdKey]?.stringValue
                    
                    // if it does not exist then set isDownloaded to false and set local URL to "none"
                    videoDictionary[Strings.sharedInstance.isDownloadedKey] = Strings.sharedInstance.falseValue
                    videoDictionary[Strings.sharedInstance.localUrlKey] = Strings.sharedInstance.localUrlEmptyValue
                    
                    // Save active and expiration dates
                    videoDictionary[Strings.sharedInstance.activeDateKey] = Strings.sharedInstance.videoActiveDates[index]
                    videoDictionary[Strings.sharedInstance.expirationDateKey] = Strings.sharedInstance.courseExpirationDate
                    
                    // Save remote url
                    if let assets = videoElements[Strings.sharedInstance.apiAssetsKey]?.array {
                        videoDictionary[Strings.sharedInstance.urlKey] = assets[1].dictionaryObject![Strings.sharedInstance.apiUrlKey] as? String
                        self.videoData.append(videoDictionary)
                    } else {
                        ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Problem extracting assets array")
                    }
                } else {
                    ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Problem extracting videoElements")
                }
            }
        } else {
            ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Problem extracting videoList")
        }
    }
}




