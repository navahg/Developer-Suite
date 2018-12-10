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
    weak var chatsDelegate: ChatDataDelegate?
    weak var teamsDelegate: TeamDataDeleagte?
    weak var repositoryDelegate: RepositoryDataDeleagte?
    
    // MARK: Life cycle hooks
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async { [weak self] in
            self?.loadChats()
            self?.loadRepositories()
        }
    }
    
    // Mark: Private Methods
    
    private func navigateToLoginScreen() {
        self.performSegue(withIdentifier: "NavigateToLoginScreen", sender: self)
    }
    
    /**
     Loads all the chats and calls the delegate method when the data is loaded
     */
    private func loadChats() {
        FirebaseService.shared.fetchChats(forUser: currentUser) {
            self.chatsDelegate?.didReceiveData(sender: self)
        }
    }
    
    private func loadRepositories() {
        if let githubUID: String = currentUser.githubId {
            GithubService.shared.getUserRepos(forUID: githubUID) { repositories, error in
                if error != nil || repositories == nil {
                    // TODO: Handle error
                    return
                }
                
                self.currentUser.repositories = NSOrderedSet(array: repositories!)
                self.repositoryDelegate?.didReceiveData(sender: self)
            }
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
