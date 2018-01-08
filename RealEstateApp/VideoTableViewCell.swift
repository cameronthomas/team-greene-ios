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
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var videoLabel: UILabel!
    
    var cellNumber = -1
    
    weak var delegate: playVideoDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            if delegate != nil {
                delegate?.playVideo(cellNumber: cellNumber)
            }
        }
    }
}
