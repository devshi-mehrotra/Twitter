//
//  TweetCell.swift
//  Twitter
//
//  Created by Devshi Mehrotra on 6/28/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var retweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.userInteractionEnabled = false
        textField.editable = false
        textField.dataDetectorTypes = .Link 
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.heartButton.imageView?.image = UIImage(named: "like") // or set a placeholder image
        
        //self.retweetButton.imageView?.image = UIImage(named: "retweet") // or set a placeholder image
    }
    

}
