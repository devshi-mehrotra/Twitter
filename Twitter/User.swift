//
//  User.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/27/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit

class User: NSObject {
    
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    var name: String?
    var screenname: String?
    var profileUrl: NSURL?
    var headerUrl: NSURL?
    var tagLine: String?
    var followersCount: Int = 0
    var followingCount: Int = 0
    var following : Bool?
    
    var dictionary: NSDictionary?
    var loadingMoreView:InfiniteScrollActivityView?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        followersCount = dictionary["followers_count"] as! Int
        followingCount = dictionary["friends_count"] as! Int
        following = dictionary["following"] as? Bool
        
        let profileUrlString = dictionary["profile_image_url"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString.stringByReplacingOccurrencesOfString("_normal", withString: ""))
        }
        
        let headerUrlString = dictionary["profile_banner_url"] as? String
        if let headerUrlString = headerUrlString {
            headerUrl = NSURL(string: headerUrlString)
        }
        
        //print(dictionary)
        
        tagLine = dictionary["description"] as? String
    }

    class func usersWithArray(dictionaries: [NSDictionary]) -> [User] {
        var users = [User]()
        
        for dictionary in dictionaries {
            let user = User(dictionary: dictionary)
            users.append(user)
        }
        
        return users
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
            
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
               let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                 defaults.setObject(nil, forKey: "currentUserData")
            }
            
            //defaults.setObject(user, forKey: "currentUser")
            defaults.synchronize()
        }
    }
}
