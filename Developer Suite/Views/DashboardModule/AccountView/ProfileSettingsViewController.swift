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
    private static let exitSegue: String = "exitToTeamTable"

    // Mark: - Properties
    var user: UserMO!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayNameTextField.text = user.displayName
        emailTextField.text = user.email
    }

    // MARK: - Actions
    @IBAction func doSaveChanges(_ sender: Any) {
        self.resignFirstResponder()
        
        guard let displayName: String = displayNameTextField.text, displayName.count > 3 else {
            Utils.showAlert(withTitle: "Invalid data", andMessage: "Display Name should have atleast 3 characters.", onViewController: self)
            return
        }
        
        guard let email: String = emailTextField.text, ProfileSettingsViewController.emailTest.evaluate(with: email)
        else {
            Utils.showAlert(withTitle: "Invalid data", andMessage: "Provide a valid email.", onViewController: self)
            return
        }
        
        if (displayName == user.displayName && email == user.email) {
            Utils.showAlert(withTitle: "Success", andMessage: "No changes made.", onViewController: self)
            return
        }
        
        let rollBackData: [String: String?] = [
            "displayName": user.displayName,
            "email": user.email
        ]
        
        user.email = email
        user.displayName = displayName
        
        FirebaseService.shared.updateUserInformation(user) { error in
            if (error != nil) {
                Utils.showAlert(withTitle: "Error", andMessage: "Unable to update the information. Try again.", onViewController: self)
                self.user.displayName = rollBackData["displayName"]!
                self.user.email = rollBackData["email"]!
                return
            }
            
            Utils.showAlert(withTitle: "Success", andMessage: "Updated the information.", onViewController: self)
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: ProfileSettingsViewController.exitSegue, sender: self)
            }
        }
    }
}
