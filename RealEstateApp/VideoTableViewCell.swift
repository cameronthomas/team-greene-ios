//
//  VideoTableViewCell.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 11/12/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit
import AVKit

protocol playVideoDelegate: NSObjectProtocol {
    func playVideo(cellNumber: Int)
}

class VideoTableViewCell: UITableViewCell
{
    var cellNumber = -1
    weak var delegate: playVideoDelegate? = nil
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var downloadDeleteButton: UIButton!
    @IBAction func downloadDeleteButtonAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Download" {
            
            // Disable button
            
            // Display spinner to right of button
            
            // Download video async
            
                // Add video to documents
            
                // Refresh view
            
            
                // MIGHT NOT NEED BELOW
                // Update UI
                // Change button title
                //sender.setTitle("Delete Download", for: .normal)
            
                // Enable button
            
                // Turn off and get rid of spinner
            
        } else {
            
            // Disable button
            
            // Display spinner to right of button
            
            // Update Video data list (NEED TO ACCESS VideoTableViewController)
            
            // Delete from docs
            
            // Update UI
            // Change button title
            sender.setTitle("Download", for: .normal)
            
            // Enable button
            
            // Turn off and get rid of spinner
        }
    }
    
    
    func downloadVideo() {
        
    }
    
    func deleteVideo() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            if delegate != nil {
                delegate?.playVideo(cellNumber: cellNumber)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
