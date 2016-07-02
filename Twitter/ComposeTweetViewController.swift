//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/29/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var composeTextField: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.composeTextField.delegate = self
        self.updateCharacterCount()
        // Do any additional setup after loading the view.
    }
    
    func updateCharacterCount() {
        self.charCountLabel.text = "\((140) - self.composeTextField.text.characters.count)"
    }
    
    func textViewDidChange(textView: UITextView) {
        self.updateCharacterCount()
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.updateCharacterCount()
        return textView.text.characters.count +  (text.characters.count - range.length) <= 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onTweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.compose({ (tweet: Tweet) in
            }, failure: { (error: NSError) in
            }, status: composeTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "%20"))
        
        composeTextField.text = ""
    }
    
    
    @IBAction func onExitButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
