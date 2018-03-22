//
//  errorHandling.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 3/21/18.
//  Copyright © 2018 Cameron Thomas. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandling {
    static let sharedInstance = ErrorHandling()
    private init() { }
    
    func displayUIErrorMessage(sender: UIViewController) {
        let alert = UIAlertController(title: "Error", message: "An error has occured. Please contact the developer.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
    func displayConsoleErrorMessage(message: String) {
        print(message)
    }
}
