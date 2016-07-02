//
//  DetailTweetViewController.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/28/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import AFNetworking

class DetailTweetViewController: UIViewController/*, UITableViewDelegate, UITableViewDataSource*/ {
    
    var tweet: Tweet?
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var textField: UITextView!
    
    
    
    
    var replies: [Tweet]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.editable = false
        textField.dataDetectorTypes = .Link
        
        textField.text = tweet?.text
        retweetLabel.text = String(tweet!.retweetCount)
        favoriteLabel.text = String(tweet!.favoritesCount)
        let timestamp = String(tweet!.timestamp!)
        timestampLabel.text = timestamp.stringByReplacingOccurrencesOfString("+0000", withString: "")
        
        let user = tweet?.user
        profPicView.setImageWithURL((user?.profileUrl)!)
        nameLabel.text = user?.name
        usernameLabel.text = "@" + (user?.screenname)!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet({ (Tweet) in
            }, failure: { (NSError) in
            }, id: tweet!.id!)
    }
    
    @IBAction func onFavoriteButton(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite({ (Tweet) in
            }, failure: { (NSError) in
            }, id: tweet!.id!)
    }
    
    
    @IBAction func onImageButton(sender: AnyObject) {
        performSegueWithIdentifier("detailToProfileSegue", sender: sender)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        let user = tweet!.user
        let profileViewController = segue.destinationViewController as! ProfileViewController
        profileViewController.isSegue =
        true
        profileViewController.user = user
    }
    

}
