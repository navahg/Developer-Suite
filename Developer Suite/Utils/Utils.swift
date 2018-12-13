//
//  Utils.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/8/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import os.log

class Utils {
    /**
     The Config plist file path
     */
    static let ConfigFilePath: String? = Bundle.main.path(forResource: "Config", ofType: "plist")
    
    /**
     Logs the text sent using os_log
     - Parameter _: The text to log
     - Parameter withType: The log type to be used, defaults to OSLogType.debug
     */
    static func log(_ text: StaticString, withType type: OSLogType = .debug) {
        os_log(text, log: .default, type: type)
    }
    
    /**
     This generates a simple UIAlert with OK Button
     - Parameter withTitle: The title of the UIAlert View
     - Parameter andMessage: The message the UI will be showing
     - Returns: The controller created with title and message sent
     */
    static func generateSimpleAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return alert
    }
    
    /**
     This shows a simple UIAlert with OK Button
     - Parameter withTitle: The title of the UIAlert View
     - Parameter andMessage: The message the UI will be showing
     - Parameter onViewController: The view controller on which the UIAlert should be shown
     */
    static func showAlert(withTitle title: String, andMessage message: String, onViewController vc: UIViewController) {
        let alert: UIAlertController = generateSimpleAlert(withTitle: title, andMessage: message)
        vc.present(alert, animated: true, completion: nil)
    }
    
    /**
     This truncates the string to the given length by appending '...' to the end
     - Parameter text: The text to be truncated
     - Parameter length: The maximun length allowed
     - Returns: The truncated string
     */
    static func truncate(_ text: String, length: Int) -> String {
        if (text.count > length) {
            return String(text.dropLast(text.count - length - 3)) + "..."
        }
        return text
    }
    
    /**
     This converts normal string to the attributed string using default primary style
     - Parameter text: The text to be attributed
     - Returns: The attributed string
     */
    static func getPrimaryAttributedText(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.primaryColor,
            NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 17)!
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
