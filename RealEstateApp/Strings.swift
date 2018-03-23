//
//  File.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 1/15/18.
//  Copyright © 2018 Cameron Thomas and Team Green Real Estate. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Strings {
    static let sharedInstance = Strings()
    private init() { }
    
    let wistiaApiUrl = "https://api.wistia.com/v1/medias.json?api_password=ac9fec394124aecbdf795889bf9ee4c0c2d79c64e37b254b1cc44d3d9c7dfef4"
    let googleSheetApiUrl = "https://sheets.googleapis.com/v4/spreadsheets/1z9feQnJrTd-jsgJolLlURnWG1D44F0GlDUgKBV6_LB0/values/Active%20Dates?key=AIzaSyACYno_h-uNsgNlcDtRd4CzLufMMPPDjgQ"
    
    let videoDataFilename = "data.plist"
    
    let nameKey = "name"
    
    let hashedIdKey = "hashed_id"
    
    let isDownloadedKey = "isDownloaded"
    
    let urlKey = "url"
    
    let localUrlKey = "localUrl"
    let localUrlEmptyValue = "none"
    
    let trueValue = "true"
    let falseValue = "false"
    
    let downloadbuttonText = "Download"
    let downloadingButtonText = "Downloading"
    let deletebuttonText = "Delete Download"
    
    let apiAssetsKey = "assets"
    let apiUrlKey = "url"
    
    let activeDateKey = "activeDate"
    let expirationDateKey = "expirationDate"
    
    let VideoTableVCSegueIdentifier = "VideoTableViewControllerSegue"
    let VideoCellIdentifier = "videoCell"
    
    let videoFileType = "mp4"
    
    var videoActiveDates =  [String]()
    var courseExpirationDate = ""
    
    let emailAddress1 = "cameroncthomas1@gmail.com"
    let emailAddress2 = "cct2491@gmail.com"
    
    let documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                             .userDomainMask, true)[0] as NSString) // Path to docs dir to save and delete videos

    /**
     * Get Course Dates from google sheet response
     */
    func getCourseDates(value: Any) {
        
        // Verify dictionary from google sheets
        guard let videoDictionary = JSON(value).dictionary
            else {
                ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error getting dictionay from JSON: getCourseDates()")
                return
        }
        
        // Save active and expiration dates to Strings singleton
        if let videoList = videoDictionary["values"] {
            for video in videoList {
                videoActiveDates.append(video.1[0].stringValue)
            }
            courseExpirationDate = videoList.arrayValue[0][1].stringValue
        }
        else {
            ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Problem converting Google sheets dates list to Json: getCourseDates()")
        }
    }
    
    /**
     * Get Course Dates from docs dir
     */
    func getCourseDatesFromMem() {
        let videoData = VideoDataSingleton.sharedInstance.videoData
        
        // Get active dates
        for video in videoData {
            if let activeDate  = video[Strings.sharedInstance.activeDateKey] {
                videoActiveDates.append(activeDate)
            } else {
                ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error getting active date from mem: getCourseDatesFromMem()")
            }
        }
        
        // Get expiration date
        if let expirationDate = videoData[0][Strings.sharedInstance.expirationDateKey] {
            courseExpirationDate = expirationDate
        } else {
            ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error getting expiration date from mem: getCourseDatesFromMem()")
        }
    }
}
