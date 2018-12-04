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

    // MARK: View hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = DataManager.shared.currentUser
    }
    
    // MARK: Private functions
    private func loadChats() {
        chats = currentUser.chats?.array as? [ChatMO]
    }
}

// MARK: Table view data source protocol implementation
extension ChatViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ChatViewController.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chats != nil {
            return chats.count
        }
        return 0
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
