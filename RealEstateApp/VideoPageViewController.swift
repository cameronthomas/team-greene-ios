//
//  VideoPageViewController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 9/25/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit
import WistiaKit


class VideoPageViewController: UIViewController {
    
    //MARK: - WistiaPlayer Specific
    let wistiaPlayer = WistiaPlayer(referrer: "WistiaKitDemo", requireHLS: false)
    @IBOutlet weak var playerView: WistiaFlatPlayerView!
    
    //MARK: - WistiaPlayerViewController Specific
    let wistiaPlayerVC = WistiaPlayerViewController(referrer: "WistiaKitDemo", requireHLS: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.wistiaPlayer = wistiaPlayer

        // Do any additional setup after loading the view.
        
        let hashedID = "j5bsei76xi"
        
        //Play using WistiaPlayerViewController
//        wistiaPlayer.replaceCurrentVideoWithVideo(forHashedID: hashedID)
//        wistiaPlayer.play()
        
        
        //Play using WistiaPlayerViewController
        wistiaPlayerVC.replaceCurrentVideoWithVideo(forHashedID: hashedID)
        self.present(wistiaPlayerVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
