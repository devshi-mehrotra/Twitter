//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/29/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profPicImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    //@IBOutlet weak var editProfButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var isSegue: Bool = false
    var user: User?
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var editProfButton: UIButton!
    
    var isMentions: Bool = false
    
    //var following: [User] = []
    var mentions: [Tweet]?
    
    var tweets: [Tweet]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControlAction(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    
        // Do any additional setup after loading the view.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        var currentUser: User?
        
        if isSegue {
            //segmentedControl.hidden = true
            segmentedControl.removeSegmentAtIndex(1, animated: true)
            
            currentUser = self.user
            exitButton.setImage(UIImage(named:"exit_icon"), forState: UIControlState.Normal)
            editProfButton.setTitle("", forState: UIControlState.Normal)
            editProfButton.layer.borderWidth = 0
            
            followButton.layer.borderWidth = 1
            followButton.layer.cornerRadius = 5
            followButton.layer.borderColor = UIColor.darkGrayColor().CGColor
            
            //print("PRINT")
            //print((following))
            if ((currentUser!.following) != false) {
                print("PRINT")
                followButton.setTitle("Following", forState: UIControlState.Normal)
                followButton.layer.borderColor = UIColor.blueColor().CGColor
                followButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                //followButton.backgroundColor = UIColor(red: 0, green: 80, blue: 255, alpha: 1)
            }
        }
        else {
            self.user = User.currentUser
            currentUser = User.currentUser
            
            followButton.setTitle("", forState: UIControlState.Normal)
            followButton.layer.borderWidth = 0
            followButton.backgroundColor = UIColor.whiteColor()
            
            editProfButton.layer.borderWidth = 1
            editProfButton.layer.cornerRadius = 5
            editProfButton.layer.borderColor = UIColor.darkGrayColor().CGColor
            
            /*TwitterClient.sharedInstance.friends({ (users:[User]) in
             self.following = users
             }, failure: { (error: NSError) in
             })*/
        }
        
        nameLabel.text = currentUser?.name
        usernameLabel.text = "@" + (currentUser?.screenname)!
        tagLabel.text = currentUser?.tagLine
        
        followingLabel.text = String(currentUser!.followingCount)
        followerLabel.text = String(currentUser!.followersCount)
        
        profPicImageView.setImageWithURL((currentUser?.profileUrl)!)
        
        if currentUser?.headerUrl != nil {
            
            headerImageView.setImageWithURL((currentUser?.headerUrl)!)
        }
        
        if isSegue {
            print(currentUser?.screenname)
            TwitterClient.sharedInstance.anotherUserTimeline({ (tweets: [Tweet]) in
                self.tweets = tweets
                }, failure: { (error: NSError) in
                }, screenname: (currentUser?.screenname)!)
        }
        else {
            TwitterClient.sharedInstance.userTimeline({ (tweets: [Tweet]) in
                self.tweets = tweets
            }) { (error: NSError) in
            }
            
            TwitterClient.sharedInstance.mentionsTimeline({ (tweets: [Tweet]) in
                self.mentions = tweets
            }) { (error: NSError) in
            }
        }
        
        isSegue = false
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            isMentions = false
            //viewDidLoad()
            tableView.reloadData()
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
           isMentions = true
            //viewDidLoad()
            tableView.reloadData()
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        //var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        let header = headerImageView
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        }
        
    
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMentions {
            return mentions!.count
        }
        else {
            return 20
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("ProfileFeedCell", forIndexPath: indexPath) as! ProfileFeedCell
        
        if isMentions {
            if mentions != nil {
                let currentTweet = mentions![indexPath.row]
                cell.textField.text = currentTweet.text
                cell.timestampLabel.text = timeAgoSinceDate(currentTweet.timestamp!, numericDates: true)
                cell.retweetLabel.text = String(currentTweet.retweetCount)
                cell.favoriteLabel.text = String(currentTweet.favoritesCount)
                
                let currentUser = currentTweet.user
                cell.profPicView.setImageWithURL((currentUser?.profileUrl)!)
                cell.nameLabel.text = currentUser?.name
                cell.usernameLabel.text = "@" + (currentUser?.screenname)!
            }
            else {
                //cell.tweetTextLabel.text = ""
                cell.timestampLabel.text = ""
                cell.retweetLabel.text = ""
                cell.favoriteLabel.text = ""
                cell.nameLabel.text = ""
                cell.usernameLabel.text = ""
            }
        }
        else {
            if tweets != nil {
                let currentTweet = tweets![indexPath.row]
                cell.textField.text = currentTweet.text
                cell.timestampLabel.text = timeAgoSinceDate(currentTweet.timestamp!, numericDates: true)
                cell.retweetLabel.text = String(currentTweet.retweetCount)
                cell.favoriteLabel.text = String(currentTweet.favoritesCount)
            
                let currentUser = currentTweet.user
                cell.profPicView.setImageWithURL((currentUser?.profileUrl)!)
                cell.nameLabel.text = currentUser?.name
                cell.usernameLabel.text = "@" + (currentUser?.screenname)!
            }
            else {
                //cell.tweetTextLabel.text = ""
                cell.timestampLabel.text = ""
                cell.retweetLabel.text = ""
                cell.favoriteLabel.text = ""
                cell.nameLabel.text = ""
                cell.usernameLabel.text = ""
            }
        }
        return cell
    }
    
    /*func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat(0.816),
            green: CGFloat(0.325),
            blue: CGFloat(0.251),
            alpha: CGFloat(1.0)
        )
    }*/
    
    @IBAction func onExitButton(sender: AnyObject) {
        print("exit")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onFollowButton(sender: AnyObject) {
        TwitterClient.sharedInstance.follow({ () in
            }, failure: { (error:NSError) in
            }, screenname: (self.user?.screenname)!)
        
        followButton.setTitle("Following", forState: UIControlState.Normal)
        followButton.layer.borderColor = UIColor.blueColor().CGColor
        followButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        //followButton.backgroundColor = UIColor(red: 0, green: 80, blue: 130, alpha: 1)
    }
    
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 2) {
            return "\(components.year)y"
        } else if (components.year >= 1){
            if (numericDates){
                return "1y"
            } else {
                return "Last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month)m"
        } else if (components.month >= 1){
            if (numericDates){
                return "1m"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1w"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day)d"
        } else if (components.day >= 1){
            if (numericDates){
                return "1d"
            } else {
                return "Yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour)h"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1h"
            } else {
                return "An hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute)m"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1m"
            } else {
                return "A minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second)s"
        } else {
            return "Just now"
        }
        
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
