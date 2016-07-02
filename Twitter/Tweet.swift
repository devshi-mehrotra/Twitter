//
//  Tweet.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/27/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var id: String?
    var favorited: Bool?
    //var retweeted: Bool?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        id = dictionary["id_str"] as? String
        favorited = (dictionary["favorited"] as? Bool)!
        //retweeted = (dictionary["retweeted"] as? Bool)!
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
          let formatter = NSDateFormatter()
          formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
          timestamp = formatter.dateFromString(timestampString)
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets 
    }

}
