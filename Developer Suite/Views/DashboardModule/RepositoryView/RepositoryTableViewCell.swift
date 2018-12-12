//
//  RepositoryTableViewCell.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/9/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    public static let identifier: String = "repository-cell"
    
    // MARK: Properties
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var activePullRequestCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
