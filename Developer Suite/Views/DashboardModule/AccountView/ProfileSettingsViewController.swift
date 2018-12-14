//
//  ProfileSettingsViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController {
    
    // MARK: - Static properties
    private static var emailTest: NSPredicate {
        let emailRegex: String = "^\\w+([.-]?\\w+)*@\\w+([.-]?\\w+)*(\\.\\w{2,3})+$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)
    }

    // Mark: - Properties
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    @IBAction func doSaveChanges(_ sender: Any) {
        guard let displayName: String = displayNameTextField.text else {
            return
        }
        
        guard let email: String = emailTextField.text, ProfileSettingsViewController.emailTest.evaluate(with: email)
        else {
            return
        }
        
        
    }
}
