//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/27/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    var userTweets: [Tweet]!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var counter = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 400

        let refreshControl = UIRefreshControl()
        refreshControlAction(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        // 1
        let nav = self.navigationController?.navigationBar
        // 2
        nav?.barStyle = UIBarStyle.BlackTranslucent
        nav?.tintColor = UIColor.whiteColor()
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.contentMode = .ScaleAspectFit
        // 4
        let image = UIImage(named: "bird-2")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
        
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        }, count: String(counter))
        
        TwitterClient.sharedInstance.userTimeline({ (tweets: [Tweet]) -> () in
            self.userTweets = tweets

            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func onComposeButton(sender: AnyObject)
    {
        performSegueWithIdentifier("feedToComposeSegue", sender: sender)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        if tweets != nil && userTweets != nil {
           let currentTweet = tweets![indexPath.row]
           cell.timestampLabel.text = String(timeAgoSinceDate(currentTweet.timestamp!, numericDates: true))
           //cell.tweetTextLabel.text = currentTweet.text
           cell.textField?.text = currentTweet.text
            
           let currentUser = currentTweet.user
           cell.nameLabel.text = currentUser!.name
           cell.usernameLabel.text = "@" + currentUser!.screenname!
           cell.profPicView.setImageWithURL((currentUser?.profileUrl)!)
           cell.retweetLabel.text = String(currentTweet.retweetCount)
           cell.favoriteLabel.text = String(currentTweet.favoritesCount)
            
            for tweet in self.userTweets {
                //print(tweet.text)
                //print(currentTweet.text)
                //print(currentUser!.name)
                //print(User.currentUser?.name)
                if tweet.text?.rangeOfString(currentTweet.text!) != nil && (currentUser!.name != User.currentUser!.name) {
                     cell.retweetButton.setImage(UIImage(named: "green-retweet-2"), forState: UIControlState.Normal)
                }
            }
            
            if (currentTweet.favorited != false) {
                cell.heartButton.imageView?.image = UIImage(named: "red-like")
            }
           
        }
        else {
            cell.timestampLabel.text = ""
            //cell.tweetTextLabel.text = ""
            cell.nameLabel.text = ""
            cell.usernameLabel.text = ""
            cell.retweetLabel.text = ""
            cell.favoriteLabel.text = ""
        }
        
        return cell
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        let currentCell = sender.superview!!.superview as! UITableViewCell
        let indexPath = tableView.indexPathForCell(currentCell)
        let currentTweet = tweets[indexPath!.row]
        
        TwitterClient.sharedInstance.retweet({ (Tweet) in
            }, failure: { (NSError) in
            }, id: currentTweet.id!)
        
        sender.imageView!!.image = UIImage(named: "green-retweet-2")
        
        print("RETWEETED")
        
        self.tableView.reloadData()
    }
    
    @IBAction func onFavoriteButton(sender: AnyObject) {
        let currentCell = sender.superview!!.superview as! UITableViewCell
        let indexPath = tableView.indexPathForCell(currentCell)
        let currentTweet = tweets[indexPath!.row]
        
        TwitterClient.sharedInstance.favorite({ (Tweet) in
            }, failure: { (NSError) in
            }, id: currentTweet.id!)
        
        sender.imageView!!.image = UIImage(named: "red-like")
        
        print("FAVORITED")
        
        self.tableView.reloadData()
    }
    
    func loadMoreData() {
        
        counter = counter + 20
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
            }, count: String(counter))
        
        /*TwitterClient.sharedInstance.userTimeline({ (tweets: [Tweet]) -> () in
            self.userTweets = tweets
            
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })*/
        
        self.isMoreDataLoading = false
        self.loadingMoreView!.stopAnimating()
        
        self.tableView.reloadData()

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()		
            }
        }
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
    
    
    @IBAction func onImageButton(sender: AnyObject) {
        performSegueWithIdentifier("feedToProfileSegue", sender: sender)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "feedToComposeSegue" {
            
        }
        else if segue.identifier == "feedToProfileSegue" {
            let cell = sender!.superview!!.superview as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let user = tweet.user
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.isSegue = 
            true
            profileViewController.user = user 
            
        }
        else {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
        
            let detailViewController = segue.destinationViewController as! DetailTweetViewController
            detailViewController.tweet = tweet
            tableView.deselectRowAtIndexPath(indexPath!, animated:true)
        }
        
    }
    

}
