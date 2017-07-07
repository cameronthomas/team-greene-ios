//
//  KeyboardUtils.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 7/2/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import Foundation
import UIKit

class KeyboardUtils {
    
    var view: UIView!
    var scrollView: UIScrollView!
    var activeField: UITextField!
    
    // Code originated from https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
    // Converted with Swiftify v1.0.6381 - https://objectivec2swift.com/
    // Modified by Cameron Thomas after conversion form Objective-C to Swift
    // Call this method somewhere in your view controller setup code.
    
    func registerForKeyboardNotifications(_ observer: LoginScreenController) {
        view = observer.view
        scrollView = observer.scrollView
        activeField = observer.activeField
        
        NotificationCenter.default.addObserver(observer, selector: #selector(KeyboardUtils.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(observer, selector: #selector(KeyboardUtils.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc private func keyboardWillShow(_ aNotification: Notification) {
        print("keyboard displayed")
        
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
    @objc private func keyboardWillBeHidden(_ aNotification: Notification) {
        print("keyboard gone")
        
        scrollView.isScrollEnabled = true
        
        //let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        //        scrollView?.contentInset = contentInsets
        //        scrollView?.scrollIndicatorInsets = contentInsets
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        //  scrollView.isScrollEnabled = false
    }
}
