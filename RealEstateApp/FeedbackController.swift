//
//  FeedbackController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 7/12/17.
//  Copyright © 2017 Cameron Thomas. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class FeedbackController: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var positiveFeedbackTextView: UITextView!
    @IBOutlet weak var improvementFeedbackTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Make keyboard disapear when tap outside of textbox
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // Add "Done" button to keyboard to make it disapear
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        positiveFeedbackTextView.inputAccessoryView = toolbar
        improvementFeedbackTextView.inputAccessoryView = toolbar
        
        // Other properties to set
        scrollView.isScrollEnabled = false
        improvementFeedbackTextView.tag = 1
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.isScrollEnabled = true
        
        // ImprovementFeedbackTextView
        if(textView.tag == 1) {
            let scrollOffset = self.scrollView.contentSize.height - self.scrollView.bounds.size.height
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset), animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.isScrollEnabled = false
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Followed example at https://www.andrewcbancroft.com/2014/08/25/send-email-in-app-using-mfmailcomposeviewcontroller-with-swift/
    // for sending emails
    @IBAction func sendFeedbackEmail(_ sender: UIButton) {
        
        // Return if both fields are blank
        guard positiveFeedbackTextView.text != "" || improvementFeedbackTextView.text != "" else {
            print("blank, gaurd")
            return
        }
        
        // Create email object
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        createEmail(mailViewController)
        
        // Show email
        if MFMailComposeViewController.canSendMail() {
            self.present(mailViewController, animated: true, completion: nil)
        } else {
            print("cannot send mail")
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        positiveFeedbackTextView.text = ""
        improvementFeedbackTextView.text = ""
    }
    
    // Create email with feedback
    func createEmail(_ mailViewController: MFMailComposeViewController) {
        var emailBody = ""
        
        mailViewController.setToRecipients([Strings.sharedInstance.emailAddress1, Strings.sharedInstance.emailAddress2])
        
        // Build HTML for email body
        if (positiveFeedbackTextView.text != "") {
            emailBody = "<span style=\"font-weight: bold\">Positive Feedback</span><br/>" + positiveFeedbackTextView.text! + "<br/><br/>"
        }
        
        if (improvementFeedbackTextView.text != "") {
            emailBody += "<span style=\"font-weight: bold\">Improvement Feedback</span><br/>" + improvementFeedbackTextView.text!
        }
        
        mailViewController.setSubject("Master Class Feedback")
        mailViewController.setMessageBody(emailBody, isHTML: true)
    }
}
