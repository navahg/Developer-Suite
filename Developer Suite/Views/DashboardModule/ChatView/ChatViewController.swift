//
//  ChatViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/18/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import MessageKit

class ChatViewController: UITableViewController {
    
    // MARK: Static Properties
    fileprivate static let numberOfSections: Int = 1
    
    // MARK: Properties
    var currentUser: UserMO!
    var chats: [ChatMO]!
    var dashboardController: DashboardTabBarController!

    // MARK: View hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardController = self.tabBarController as? DashboardTabBarController
        dashboardController.chatsDelegate = self
        
        loadData()
    }
    
    // MARK: Private functions
    private func loadData() {
        if let currentUser = dashboardController.currentUser {
            self.currentUser = currentUser
            self.chats = currentUser.chats?.array as? [ChatMO] ?? []
        }
    }
}

// MARK: DashboardTabBarController delegates
extension ChatViewController: ChatDataDelegate {
    func didReceiveData(sender: DashboardTabBarController) {
        if let chats: [ChatMO] = sender.currentUser.chats?.array as? [ChatMO] {
            self.chats = chats
            tableView.reloadData()
        }
    }
}

// MARK: Table view data source protocol implementation
extension ChatViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ChatViewController.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell: ChatTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: ChatTableViewCell.identifier,
                for: indexPath) as? ChatTableViewCell else {
                    fatalError("The table view cell is not of type ChatTableViewCell")
        }
        
        // Configure cell
        let currentChat: ChatMO = chats[indexPath.row]
        cell.recipientNameLabel.text = currentChat.recipientName
        cell.messageLabel.text = (currentChat.messages?.lastObject as? MessageMO)?.message ?? ""
        
        return cell
    }
}
