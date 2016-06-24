//
//  postTableViewCell.swift
//  Instagram
//
//  Created by Allison Tang on 6/21/16.
//  Copyright © 2016 Allison Tang. All rights reserved.
//

import UIKit
import Parse

class postTableViewCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    var likes = 0
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    

    
    
    @IBAction func likeButton(sender: AnyObject) {
        likes += 1
        likesLabel.text = "\(likes)"
        
    }

    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var recapLabel: UILabel!
    
    @IBAction func detailTap(sender: AnyObject) {
        self.detailView.hidden = false
        
        
    }
 
    
    @IBOutlet weak var pictureView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.detailView.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
