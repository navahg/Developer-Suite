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
    
    // MARK: Custom Delegates
    var chatsDelegate: ChatDataDelegate?
    var teamsDelegate: TeamDataDeleagte?
    
    // MARK: Life cycle hooks
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadChats()
    }
    
    // Mark: Private Methods
    
    private func navigateToLoginScreen() {
        self.performSegue(withIdentifier: "NavigateToLoginScreen", sender: self)
    }
    
    private func loadChats() {
        FirebaseService.shared.fetchChats(forUser: currentUser) {
            self.chatsDelegate?.didReceiveData(sender: self)
        }
    }
    
    // Mark: Public methods
    func doSignOut() {
        do {
            try Auth.auth().signOut()
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
