//
//  ParsedTweetCellTableViewCell.swift
//  PragmaticTweets
//
//  Created by Sergey Bavykin on 3/16/16.
//  Copyright © 2016 Sergey Bavykin. All rights reserved.
//

import UIKit

class ParsedTweetCellTableViewCell: UITableViewCell {


    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
