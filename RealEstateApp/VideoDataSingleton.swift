//
//  VideoData.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 1/15/18.
//  Copyright © 2018 Cameron Thomas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VideoDataSingleton {
    static let sharedInstance = VideoDataSingleton()
    private init() { }
    
    let filePath =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(Strings.sharedInstance.videoDataFilename)
    
    var videoData: [Dictionary<String, String>] {
        get {
            return NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as? [Dictionary<String, String>] ?? []
        }
        set {
            NSKeyedArchiver.archiveRootObject(newValue, toFile: filePath.path)
        }
    }
    
    func alamoFireAndSwiftyJson(result: Result<Any>) {
        switch result {
        case .success(let value):
            let json = JSON(value)
            
            if let videoList = json.array {
                for (index, videoObject) in videoList.enumerated() {
                    var videoDictionary = [String: String]()
                    
                    if let videoElements = videoObject.dictionary {
                        videoDictionary[Strings.sharedInstance.nameKey] = videoElements[Strings.sharedInstance.nameKey]?.stringValue
                        videoDictionary[Strings.sharedInstance.hashedIdKey] = videoElements[Strings.sharedInstance.hashedIdKey]?.stringValue
                        
                        // if it does not exist then set isDownloaded to false and set local URL to "none"
                        videoDictionary[Strings.sharedInstance.isDownloadedKey] = Strings.sharedInstance.falseValue
                        videoDictionary[Strings.sharedInstance.localUrlKey] = Strings.sharedInstance.localUrlEmptyValue
                        
                        // Replace line below with array returned from google sheet
                        videoDictionary[Strings.sharedInstance.activeDateKey] = Strings.sharedInstance.videoActiveDates[index]
                        
                        if let assets = videoElements[Strings.sharedInstance.apiAssetsKey]?.array {
                            videoDictionary[Strings.sharedInstance.urlKey] = assets[1].dictionaryObject![Strings.sharedInstance.apiUrlKey] as? String
                            self.videoData.append(videoDictionary)
                            
                            print()
                            print(videoDictionary)
                            print()
                        }
                        else {
                            print("Problem extracting assets array")
                        }
                    }
                    else {
                        print("Problem extracting videoElements")
                    }
                }
            } else {
                print("Problem extracting videoList")
            }
            
        case .failure(let error):
            print(error)
        }
    }
}




