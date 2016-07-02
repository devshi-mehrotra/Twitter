//
//  ProfileFeedCell.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/29/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit

class ProfileFeedCell: UITableViewCell {

    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    //@IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.editable = false
        textField.dataDetectorTypes = .Link
        // Initialization code
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
