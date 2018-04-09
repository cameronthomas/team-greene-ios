//
//  FeedbackController.swift
//  RealEstateApp
//
//  Created by Cameron Thomas on 7/12/17.
//  Copyright © 2017 Cameron Thomas and Team Green Real Estate. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class FeedbackController: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var positiveFeedbackTextView: UITextView!
    @IBOutlet weak var improvementFeedbackTextView: UITextView!
    
    /**
     * viewDidLoad
     */
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
    
    /**
     * Text View Did Begin Editing
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.isScrollEnabled = true
        
        // ImprovementFeedbackTextView
        if(textView.tag == 1) {
            let scrollOffset = self.scrollView.contentSize.height - self.scrollView.bounds.size.height
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset), animated: true)
        }
    }
    
    /**
     * Text View Did End Editing
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.isScrollEnabled = false
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    /**
     * Dismiss keyboard
     */
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     * Send Feedback Email
     * Followed example at https://www.andrewcbancroft.com/2014/08/25/send-email-in-app-using-mfmailcomposeviewcontroller-with-swift/
     * for sending emails
     */
    @IBAction func sendFeedbackEmail(_ sender: UIButton) {
        
        // Return if both fields are blank
        guard positiveFeedbackTextView.text != "" || improvementFeedbackTextView.text != "" else {
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
    
    /**
     * Mail Compose Controller
     */
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        positiveFeedbackTextView.text = ""
        improvementFeedbackTextView.text = ""
    }
    
    /**
     * Create email with feedback
     */
    func createEmail(_ mailViewController: MFMailComposeViewController) {
        var emailBody = ""
        
        mailViewController.setToRecipients([Strings.sharedInstance.emailAddress1, Strings.sharedInstance.emailAddress2, Strings.sharedInstance.emailAddress3]) // Set recipients
        
        
        // Get feedback from text views
        guard let positiveFeedbackText = positiveFeedbackTextView?.text,
            let improvementFeedbackText = improvementFeedbackTextView?.text else {
                ErrorHandling.sharedInstance.displayConsoleErrorMessage(message: "Error creating email: createEmail()")
                ErrorHandling.sharedInstance.displayUIErrorMessage(sender: self)
                self.view.isUserInteractionEnabled = false
                return
        }
        
        // Build HTML for email body
        if (positiveFeedbackText != "") {
            emailBody = "<span style=\"font-weight: bold\">Positive Feedback</span><br/>" + positiveFeedbackText + "<br/><br/>"
        }
        
        if (improvementFeedbackText != "") {
            emailBody += "<span style=\"font-weight: bold\">Improvement Feedback</span><br/>" + improvementFeedbackText
        }
        
        mailViewController.setSubject("Master Class Feedback")
        mailViewController.setMessageBody(emailBody, isHTML: true)
    }
}
