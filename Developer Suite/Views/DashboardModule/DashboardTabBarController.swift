//
//  DashboardTabBarController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/11/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import FirebaseAuth

class DashboardTabBarController: UITabBarController {
    
    // Mark: Properties
    var currentUser: UserMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DataManager.shared.currentUser = currentUser
    }
    
    // Mark: Private Methods
    
    private func navigateToLoginScreen() {
        self.performSegue(withIdentifier: "NavigateToLoginScreen", sender: self)
    }
    
    // Mark: Public methods
    func doSignOut() {
        do {
            try Auth.auth().signOut()
            DataManager.shared.currentUser = nil
            navigateToLoginScreen()
        } catch {
            self.present(
                Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Unable to log out. Try Again."),
                animated: true,
                completion: nil)
            Utils.log("Unable to signout user.")
        }
    }
}

// MARK: Navigation delegates

extension DashboardTabBarController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ChatViewController") {
            guard let navController: UINavigationController = segue.destination as? UINavigationController,
                let destinationVC: OAuthWebViewController = navController.topViewController as? OAuthWebViewController
                else {
                    Utils.log("The destination Controller is not of extected type for PresentOAuthWebView segue.")
                    return
            }
            destinationVC.url = LoginViewController.getGithHubAuthURL()
        }
    }
}
