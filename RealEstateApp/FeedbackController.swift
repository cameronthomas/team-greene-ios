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

class FeedbackController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var positiveFeedback: UITextView!
    @IBOutlet weak var improvementFeedback: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize.height = 1000
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchedScreen(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        //self.scrollView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0)
    }
    
    // Dismiss keyboard when outside of text boxes in tappedd
    func touchedScreen(gesture: UITapGestureRecognizer) {
        positiveFeedback.resignFirstResponder()
        improvementFeedback.resignFirstResponder()
    }
    
    
    // Followed example at https://www.andrewcbancroft.com/2014/08/25/send-email-in-app-using-mfmailcomposeviewcontroller-with-swift/
    // for sending emails
    
    // Create and open mail view controller
    @IBAction func sendFeedbackEmail(_ sender: UIButton) {
        
        // Return if both fields are blank
        guard positiveFeedback.text != "" || improvementFeedback.text != "" else {
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        
        createEmail(mailViewController)
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailViewController, animated: true, completion: nil)
        } else {
            print("cannot send mail")
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        positiveFeedback.text = ""
        improvementFeedback.text = ""
    }
    
    // Create email with feedback
    func createEmail(_ mailViewController: MFMailComposeViewController) {
        var emailBody: String = ""
        
        mailViewController.setToRecipients(["cct2491@gmail.com", "cameroncthomas1@gmail.com"])
        
        // Build HTML for email body
        if (positiveFeedback.text != "") {
            emailBody = "<span style=\"font-weight: bold\">Positive Feedback</span><br/>" + positiveFeedback.text! + "<br/><br/>"
        }
        
        if (improvementFeedback.text != "") {
            emailBody += "<span style=\"font-weight: bold\">Improvement Feedback</span><br/>" + improvementFeedback.text!
        }
        
        mailViewController.setSubject("Master Class Feedback")
        mailViewController.setMessageBody(emailBody, isHTML: true)
    }
}
