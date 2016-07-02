//
//  LoginViewController.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/27/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let gradient: CAGradientLayer = CAGradientLayer()
        //gradient.frame = view.bounds
        //gradient.colors = [UIColor.greenColor().CGColor, UIColor.blueColor().CGColor]
        //backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        
        loginView.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        
        TwitterClient.sharedInstance.login({
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) in
                print("Error: \(error.localizedDescription)")
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
