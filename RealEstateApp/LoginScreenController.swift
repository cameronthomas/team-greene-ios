//
//  ViewController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 6/29/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit
import Foundation
//import AeroGearHttp
import AeroGearOAuth2
import p2_OAuth2

class LoginScreenController: UIViewController {
   // var http: Http!
    
    private let infusionsoftAuthorizationUrl = "https://signin.infusionsoft.com/app/oauth/authorize"
    private let oAuthKey = "aahp5mxqw7gy2fhswv98jq48"
    private let clientSecret = "PTbdAf3cmM"
    private let scope = "full"
    private let responseType = "code"
    private let redirectUri = "myapp://edu.byui.cctski.RealEstateApp"
    
    var loader: OAuth2DataLoader? = nil

    //
//    @IBAction func infusionsoftAuthenticate(_ sender: UIButton) {
////        let infusionsoftAuthorizationUrl = "?client_id=" + oAuthKey + "&scope=" + scope + "&response_type=" + responseType + "&redirect_uri=" + redirectUri
//
//
//
//
//
//        let oauth2 = OAuth2CodeGrant(settings: [
//            "client_id": oAuthKey,
//           // "client_secret": clientSecret,
//            "authorize_uri": infusionsoftAuthorizationUrl,
//          //  "token_uri": "https://api.infusionsoft.com/token",   // code grant only
//            "redirect_uris": [redirectUri],   // register your own "myapp" scheme in Info.plist
//            "scope": scope,
//          //  "keychain": false,         // if you DON'T want keychain integration
//            ] as OAuth2JSON)
//
//
//
//
//        let url = URL(string: "https://api.infusionsoft.com")!
//
//        var req = oauth2.request(forURL: url)
//        req.addValue("application/json", forHTTPHeaderField: "Accept")
//       // req.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
//
//        self.loader = OAuth2DataLoader(oauth2: oauth2)
//        loader?.perform(request: req) { response in
//            do {
//                let dict = try response.responseJSON()
//                DispatchQueue.main.async {
//                    print("no eror")
//                }
//            }
//            catch let error {
//                DispatchQueue.main.async {
//                    print("error:", error)
//                }
//            }
//        }
//
//
//
//    }
//
    
    

    @IBAction func infusionsoftAuthenticate(_ sender: UIButton) {
        
        if let url = URL(string: infusionsoftAuthorizationUrl +
            "?client_id=" + oAuthKey +
            "&scope=" + scope +
            "&response_type=" + responseType +
            "&redirect_uri=" + redirectUri) {
//            UIApplication.shared.open(url)
            
            let oauth2 = OAuth2CodeGrant(settings: [
                "client_id": oAuthKey,
              //  "client_secret": clientSecret,
                "authorize_uri": infusionsoftAuthorizationUrl,
                "token_uri": "https://api.infusionsoft.com/token",   // code grant only
                "redirect_uris": [redirectUri],   // register your own "myapp" scheme in Info.plist
                "scope": scope,
                //  "keychain": false,         // if you DON'T want keychain integration
                ] as OAuth2JSON)
            
            do {
                let url = try oauth2.authorizeURL(params: nil)
                try oauth2.authorizer.openAuthorizeURLInBrowser(url)

//                oauth2.afterAuthorizeOrFail = { authParameters, error in
//                    print("hi")
//                    // inspect error or oauth2.accessToken / authParameters or do something else
//                }
            } catch {
                print("error")
                print(error)
            }
        }
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.http = Http()
    }
}




//class LoginScreenController: UIViewController {
//    private let infusionsoftAuthorizationUrl = "https://signin.infusionsoft.com/app/oauth/authorize"
//    private let oAuthKey = "aahp5mxqw7gy2fhswv98jq48"
//    private let scope = "full"
//    private let responseType = "code"
//    private let redirectUri = "realEstateApp://"
//
//    @IBAction func infusionsoftAuthenticate(_ sender: UIButton) {
//        if let url = URL(string: infusionsoftAuthorizationUrl +
//            "?client_id=" + oAuthKey +
//            "&scope=" + scope +
//            "&response_type=" + responseType +
//            "&redirect_uri=" + redirectUri) {
//            UIApplication.shared.open(url)
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}

