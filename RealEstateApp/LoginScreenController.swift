//
//  ViewController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 6/29/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit
import Foundation

class LoginScreenController: UIViewController {
    private let infusionsoftAuthorizationUrl = "https://signin.infusionsoft.com/app/oauth/authorize"
    private let oAuthKey = "aahp5mxqw7gy2fhswv98jq48"
    private let scope = "full"
    private let responseType = "code"
    private let redirectUri = "realEstateApp://"
    
    @IBAction func infusionsoftAuthenticate(_ sender: UIButton) {
        if let url = URL(string: infusionsoftAuthorizationUrl +
            "?client_id=" + oAuthKey +
            "&scope=" + scope +
            "&response_type=" + responseType +
            "&redirect_uri=" + redirectUri) {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

