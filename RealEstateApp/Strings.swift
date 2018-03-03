//
//  File.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 1/15/18.
//  Copyright © 2018 Cameron Thomas. All rights reserved.
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
    
    let VideoTableVCSegueIdentifier = "VideoTableViewControllerSegue"
    let VideoCellIdentifier = "videoCell"
    
    let videoFileType = "mp4"
    
    var videoActiveDates =  [String]()
    var courseExpirationDate = ""
    
    let emailAddress1 = "cameroncthomas1@gmail.com"
    let emailAddress2 = "cct2491@gmail.com"

    func getCourseDates(result: Result<Any>) {
        switch result {
        case .success(let value):
            if let videoList = JSON(value).dictionary!["values"] {
                for video in videoList {
                    videoActiveDates.append(video.1[0].stringValue)
                }
                
                courseExpirationDate = videoList.arrayValue[0][1].stringValue
            }
        case .failure(let error):
            print(error)
        }
    }
}
