//
//  MainTableViewController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 1/9/18.
//  Copyright © 2018 Cameron Thomas and Team Green Real Estate. All rights reserved.
//

import UIKit
import Alamofire

class MainTableViewController: UITableViewController {
    let numberOfItemsInTable = 2
    
    /**
     * Prepare for segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Video list segue
        if (segue.identifier == Strings.sharedInstance.VideoTableVCSegueIdentifier) {
            if VideoDataSingleton.sharedInstance.videoData.isEmpty {
                print("new data fetched")
                
                // Get data from Google sheet
                Alamofire.request(Strings.sharedInstance.googleSheetApiUrl, method: .get).validate().responseJSON { response in
                    print("Google Alamofire request")
                    switch response.result {
                    case .success(let value):
                        Strings.sharedInstance.getCourseDates(value: value)  // Save dates from response to Strings singleton
                        self.getWistiaData(segue: segue)
                    case .failure(let error):
                        ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Alamofire Google sheet request failure: " + error.localizedDescription)
                        ErrorHandling.sharedInstance.displayUIErrorMessage(sender: self)
                    }                    
                }
            } else {
                Strings.sharedInstance.getCourseDatesFromMem()   // Save dates from documents directory to Strings singleton
                (segue.destination as! VideoTableViewController).loadDataInView()
            }
        }
    }
    
    /**
     * Get video metadata from Wistia
     */
    func getWistiaData(segue: UIStoryboardSegue) {
        Alamofire.request(Strings.sharedInstance.wistiaApiUrl, method: .get).validate().responseJSON { response in
            print("Wistia Alamofire request")
            
            switch response.result {
            case .success(let value):
                VideoDataSingleton.sharedInstance.populateVideoDataList(value: value) // Save video metadata from response to video data list in docs dir
                DispatchQueue.main.async {
                    (segue.destination as! VideoTableViewController).loadDataInView()
                }
            case .failure(let error):
                ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Alamofire Wistia request failure: " + error.localizedDescription)
                ErrorHandling.sharedInstance.displayUIErrorMessage(sender: self)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numberOfItemsInTable
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
}
