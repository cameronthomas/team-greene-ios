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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      // scrollView.isScrollEnabled = false
        registerForKeyboardNotifications()
        
        //////// Still doesn't work 
        
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(self.doneEditing)))
        
        
        
        
        
        
        
        //////
    }
    
    func doneEditing() {
        print("done editing")
        //self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activeField: UITextField!
    
    // Code originated from https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
    // Converted with Swiftify v1.0.6381 - https://objectivec2swift.com/
    // Modified by Cameron Thomas after conversion form Objective-C to Swift
    // Call this method somewhere in your view controller setup code.
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc func keyboardWillShow(_ aNotification: Notification) {
        print("keyboard displayed")
        
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
        
    }

    
    // Called when the UIKeyboardWillHideNotification is sent
    @objc func keyboardWillBeHidden(_ aNotification: Notification) {
        print("keyboard gone")
        
        
        
        
        
        //        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        //        scrollView?.contentInset = contentInsets
        //        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    
    
    
    
    
    
    
    
    
}

