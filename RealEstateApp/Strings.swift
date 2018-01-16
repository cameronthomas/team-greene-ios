//
//  File.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 1/15/18.
//  Copyright © 2018 Cameron Thomas. All rights reserved.
//

import Foundation

class Strings {
    static let sharedInstance = Strings()
    
    let wistiaApiUrl = "https://api.wistia.com/v1/medias.json?api_password=ac9fec394124aecbdf795889bf9ee4c0c2d79c64e37b254b1cc44d3d9c7dfef4"
    
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
    let deletebuttonText = "Delete Download"
    
    let apiAssetsKey = "assets"
    let apiUrlKey = "url"
    
    let VideoTableVCSegueIdentifier = "VideoTableViewControllerSegue"
    let VideoCellIdentifier = "videoCell"
    
    let videoFileType = "mp4"
}
