//
//  FriendCell.swift
//  FriendSigns
//
//  Created by Max Rogers on 8/26/15.
//  Copyright (c) 2015 max rogers. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    @IBOutlet var signImageView: UIImageView!
    @IBOutlet var userAvatar: UIImageView!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
