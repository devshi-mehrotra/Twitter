//
//  TwitterClient.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/27/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
     static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "KNE2X5Pj9eRVtDlONIzKU4hKC", consumerSecret: "lHEYYPqRgvqjyeDcZFjr5I6H5I6XkjiNrfDBQQjyEuyy7AKM6a")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> (), count: String) {
        
        GET("1.1/statuses/home_timeline.json?count=\(count)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }
    
    func mentionsTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }
    
    
    func userTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/user_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }
    
    func anotherUserTimeline(success: ([Tweet]) -> (), failure: (NSError) -> (), screenname: String) {
        
        GET("1.1/statuses/user_timeline.json?screen_name=\(screenname)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }
    
    func retweet(success: (Tweet) -> (), failure: (NSError) -> (), id: String) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            
            success(tweet)
    
        }) { (task: NSURLSessionDataTask?, error: NSError) in
             failure(error)
        }
    }
    
    func favorite(success: (Tweet) -> (), failure: (NSError) -> (), id: String) {
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            
            success(tweet)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }

    }
    
    func follow(success: () -> (), failure: (NSError) -> (), screenname: String) {
        POST("1.1/friendships/create.json?screen_name=\(screenname)&follow=true", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func unfollow(success: () -> (), failure: (NSError) -> (), screenname: String) {
        POST("1.1/friendships/destroy.json?screen_name=\(screenname)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    
    func compose(success: (Tweet) -> (), failure: (NSError) -> (), status: String) {
        POST("1.1/statuses/update.json?status=\(status)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            
            success(tweet)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
        
    }

    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress:nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
    
    func login(success: ()->(), failure: (NSError)->()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) in
            self.loginFailure?(error)
        }
    }
    
    func search(success: ([User]) -> (), failure: (NSError) -> (), screenname: String) {
        GET("https://api.twitter.com/1.1/users/search.json?q=\(screenname)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            //print(response)
            let dictionaries = response as! [NSDictionary]
            
            let users = User.usersWithArray(dictionaries)
            
            success(users)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
        
    }
    
    
    /*func friends(success: ([User]) -> (), failure: (NSError) -> ()) {
        GET("1.1/friends/ids.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            //print(response)
            let dictionaries = response as! [NSDictionary]
            
            let users = User.usersWithArray(dictionaries)
            
            success(users)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
        
    }*/
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
     
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("https://api.twitter.com/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("I got the access token!")
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            
        }) {(error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }

        
    }
    

}
