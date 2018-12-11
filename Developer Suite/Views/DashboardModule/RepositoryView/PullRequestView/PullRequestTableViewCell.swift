//
//  PullRequestTableViewCell.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class PullRequestTableViewCell: UITableViewCell {
    
    // MARK: Static Properties
    internal static let subtitleStringFormat: String = "#%d opened by %@"
    public static let identifier: String = "pull-request-detail"
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
