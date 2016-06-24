//
//  yourTableViewCell.swift
//  Instagram
//
//  Created by Allison Tang on 6/22/16.
//  Copyright © 2016 Allison Tang. All rights reserved.
//

import UIKit

class yourTableViewCell: UITableViewCell {
    

    
    @IBOutlet weak var capLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
  
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
