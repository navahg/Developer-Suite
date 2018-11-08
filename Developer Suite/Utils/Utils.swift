//
//  Utils.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/8/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func generateSimpleAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return alert
    }
}
