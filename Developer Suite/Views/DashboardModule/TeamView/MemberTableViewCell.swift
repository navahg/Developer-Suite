//
//  MemberTableViewCell.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/12/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    
    public static let identifier: String = "team-member-cell"
    
    public var member: MembersMO!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var displayPictureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
