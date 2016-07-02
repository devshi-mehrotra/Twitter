//
//  SearchViewController.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/30/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    var users: [User] = []
    @IBOutlet weak var tableView: UITableView!
    //var didTextChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        TwitterClient.sharedInstance.search({ (users:[User]) in
            //print(users)
            //print(self.users.count)
            self.users = users
            self.tableView.reloadData()
            }, failure: { (error: NSError) in
                
            }, screenname: (searchBar.text?.stringByReplacingOccurrencesOfString(" ", withString: "%20"))!)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(users.count)
        return self.users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCell

        cell.profPicView.setImageWithURL(users[indexPath.row].profileUrl!)
        cell.profPicView.layer.cornerRadius = 10
        cell.profPicView.clipsToBounds = true 
        cell.nameLabel.text = users[indexPath.row].name
        cell.usernameLabel.text = "@" + users[indexPath.row].screenname!
        
        
        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let user = users[indexPath!.row]
        let profileViewController = segue.destinationViewController as! ProfileViewController
        profileViewController.isSegue =
        true
        profileViewController.user = user
        tableView.deselectRowAtIndexPath(indexPath!, animated:true)

    }

}
