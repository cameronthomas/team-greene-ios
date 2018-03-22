//
//  MainTableViewController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 1/9/18.
//  Copyright © 2018 Cameron Thomas. All rights reserved.
//

import UIKit
import Alamofire

class MainTableViewController: UITableViewController {
    let numberOfItemsInTable = 2

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Video list segue
        if (segue.identifier == Strings.sharedInstance.VideoTableVCSegueIdentifier) {
            if VideoDataSingleton.sharedInstance.videoData.isEmpty {
                print("new data fetched")
                
                Alamofire.request(Strings.sharedInstance.googleSheetApiUrl, method: .get).validate().responseJSON { response in
                    print("Google Alamofire request")
                     switch response.result {
                     case .success(let value):
                        Strings.sharedInstance.getCourseDates(value: value)
                        self.getWistiaData(segue: segue)
                     case .failure(let error):
                        ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Alamofire Google sheet request failure: " + error.localizedDescription)
                        ErrorHandling.sharedInstance.displayUIErrorMessage(sender: self)
                    }                    
                }
            } else {
                Strings.sharedInstance.getCourseDatesFromMem()
                (segue.destination as! VideoTableViewController).loadDataInView()
            }
        }
    }
    
    func getWistiaData(segue: UIStoryboardSegue) {
        Alamofire.request(Strings.sharedInstance.wistiaApiUrl, method: .get).validate().responseJSON { response in
            print("Wistia Alamofire request")
            
            switch response.result {
            case .success(let value):
                VideoDataSingleton.sharedInstance.populateVideoDataList(value: value)
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
