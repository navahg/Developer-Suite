//
//  DashboardViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/11/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {
    
    // Mark: Properties
    var currentUser: UserModel!
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showDetails()
    }
    
    // Mark: Private Methods
    private func showDetails() {
        guard let name: String = currentUser.displayName else {
            testLabel.text = "User data not found"
            return
        }
        
        testLabel.text = name
    }
    
    private func navigateToLoginScreen() {
        self.performSegue(withIdentifier: "NavigateToLoginScreen", sender: self)
    }
    
    // Mark: Actions
    @IBAction func doSignOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen()
        } catch {
            Utils.log("Unable to signout user.")
        }
    }
}
