//
//  PartnerContactInfoController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 7/13/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit

class PartnerContactInfoController: UIViewController, GIDSignInUIDelegate {

    @IBAction func GoogleSignInButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
}
