//
//  PartnerContactInfoController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 7/13/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit
import AVKit

class PartnerContactInfoController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoURL = URL(string: "http://embed.wistia.com/deliveries/98beab4bcad64965ea2a196d35fc26ef7d1ed7c1.bin")
        
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
