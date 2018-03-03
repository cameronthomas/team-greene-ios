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
                    print("Google alamo fire")
                    Strings.sharedInstance.getCourseDates(result: response.result)
                    self.getWistiaData(segue: segue)
                }
            } else {
                DispatchQueue.main.async {
                    (segue.destination as! VideoTableViewController).loadDataInView()
                }
            }
        }
    }
    
    func getWistiaData(segue: UIStoryboardSegue) {
        Alamofire.request(Strings.sharedInstance.wistiaApiUrl, method: .get).validate().responseJSON { response in
            print("wistia Alamo fire")
            VideoDataSingleton.sharedInstance.alamoFireAndSwiftyJson(result: response.result)
            DispatchQueue.main.async {
                (segue.destination as! VideoTableViewController).loadDataInView()
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
