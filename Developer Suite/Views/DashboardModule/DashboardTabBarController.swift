//
//  DashboardTabBarController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/11/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DashboardTabBarController: UITabBarController {
    
    // Mark: Properties
    var currentUser: UserMO!
    var chatListeners: [ListenerRegistration] = []

    // MARK: Custom Delegates
    weak var chatsDelegate: ChatDataDelegate?
    weak var teamsDelegate: TeamDataDeleagte?
    weak var messagesDelegate: MessageDelegate?
    
    // MARK: Life cycle hooks
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadChats()
        self.loadTeams()
    }
    
    deinit {
        for listener: ListenerRegistration in chatListeners {
            listener.remove()
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
            self.addListeners()
            self.chatsDelegate?.didReceiveData(sender: self)
        }
    }
    
    /**
     Adds listeners to chats
     */
    private func addListeners() {
        for chat in currentUser.chats?.array ?? [] {
            guard let chatMO: ChatMO = chat as? ChatMO else {
                continue
            }
            let listenerRegistration: ListenerRegistration = FirebaseService.shared.listenForNewMessages(inChat: chatMO) { message in
                chatMO.addToMessages(message)
                
                DispatchQueue.main.async {
                    self.chatsDelegate?.didReceiveData(sender: self)
                    self.messagesDelegate?.didReceiveNewMessage(message)
                }
            }
            
            chatListeners.append(listenerRegistration)
        }
    }
    
    /**
     Loads all the teams and calls the delegate method when the data is loaded
     */
    private func loadTeams() {
        FirebaseService.shared.fetchTeams(forUser: currentUser) {
            self.teamsDelegate?.didReceiveData(sender: self)
        }
    }
    
    // Mark: Public methods
    func doSignOut() {
        do {
            try Auth.auth().signOut()
            
            // Remove the acess token from the user defaults
            UserDefaults.standard.removeObject(forKey: "githubAccessToken")
            
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
