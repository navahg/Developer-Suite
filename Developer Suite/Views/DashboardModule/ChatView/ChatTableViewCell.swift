//
//  ChatTableViewCell.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/27/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    // MARK: Static Properties
    internal static let identifier: String = "chat-item"

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
