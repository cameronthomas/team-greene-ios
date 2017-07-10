//
//  ViewController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 6/29/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit
import Foundation
import AeroGearHttp
import AeroGearOAuth2

class LoginScreenController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    var activeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.isScrollEnabled = false
        
        registerForKeyboardNotifications()
        
        // Add gesture recognizers to dismiss keyboard
        // Tap gesture
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneEditing)))
        
        // Swipe down gesture
        let swipeRecognizer: UISwipeGestureRecognizer  = UISwipeGestureRecognizer(target: self, action: #selector(doneEditing))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    // Make keyboard dismiss
    func doneEditing() {
        scrollView.endEditing(true)
    }
    
 
    @IBAction func textFieldDidBecomeActive(_ sender: UITextField) {
        activeField = sender
    }
    
    // Code originated from https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
    // Converted with Swiftify v1.0.6381 - https://objectivec2swift.com/
    // Modified by Cameron Thomas after conversion form Objective-C to Swift
    // Call this method somewhere in your view controller setup code.
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc func keyboardWillShow(_ aNotification: Notification) {
        scrollView.isScrollEnabled = true
        
        let info: [AnyHashable: Any]? = aNotification.userInfo
        let kbSize: CGSize? = (info?[UIKeyboardFrameBeginUserInfoKey] as? CGRect)?.size
        let contentInsets: UIEdgeInsets? = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        scrollView?.contentInset = contentInsets!
        scrollView?.scrollIndicatorInsets = contentInsets!
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = view.frame
        aRect.size.height -= (kbSize?.height)!
        if !aRect.contains((activeField?.frame.origin)!) {
            scrollView?.scrollRectToVisible((activeField?.frame)!, animated: true)
        }
        
        scrollView.isScrollEnabled = false
    }

    
    // Called when the UIKeyboardWillHideNotification is sent
    @objc func keyboardWillBeHidden(_ aNotification: Notification) {
        scrollView.isScrollEnabled = false
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    
    
    
    
    
    
    
    
}

