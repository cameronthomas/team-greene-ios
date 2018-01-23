//
//  MainTableViewController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 1/9/18.
//  Copyright © 2018 Cameron Thomas. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let numberOfItemsInTable = 2
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Video list segue
        if (segue.identifier == Strings.sharedInstance.VideoTableVCSegueIdentifier) {
            
            let videoTableVC:VideoTableViewController = segue.destination as! VideoTableViewController
            let url = URL(string: Strings.sharedInstance.wistiaApiUrl)
            
            // Download video metadata
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error ?? "Problem with error in creating URL for video metadata")
                } else {
                    
                    VideoDataSingleton.sharedInstance.videoDataRecieved = data
                    VideoDataSingleton.sharedInstance.processData()
                    
                    DispatchQueue.main.async {
                        videoTableVC.loadDataInView()
                        
                    }
                }
            }
            
            task.resume()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        
        let stringFromDataBase = "2018-01-22 21:55:00"
        let date1: Date? = dateFormatterGet.date(from: stringFromDataBase)

        print(date1! < Date())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numberOfItemsInTable
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
   
}
