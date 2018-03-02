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
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Video list segue
        if (segue.identifier == Strings.sharedInstance.VideoTableVCSegueIdentifier) {
            if VideoDataSingleton.sharedInstance.videoData.isEmpty {
                print("new data fetched")
                
                Alamofire.request(Strings.sharedInstance.wistiaApiUrl, method: .get).validate().responseJSON { response in
                    VideoDataSingleton.sharedInstance.alamoFireAndSwiftyJson(result: response.result)
                    DispatchQueue.main.async {
                        (segue.destination as! VideoTableViewController).loadDataInView()
                    }
                }
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
