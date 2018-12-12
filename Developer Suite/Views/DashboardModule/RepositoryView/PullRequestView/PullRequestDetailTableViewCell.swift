//
//  PullRequestDetailTableViewCell.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/11/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class PullRequestDetailTableViewCell: UITableViewCell {
    
    // MARK: Static Properties
    public static let identifier: String = "pr-details"
    internal static let prNumberStringFormat: String = "#%d"
    internal static let commitDescriptionStringFormat: String = " wants to merge %d commits"
    
    // MARK: Instance Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var baseLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var commitDescriptionLabel: UILabel!
    @IBOutlet weak var prNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
