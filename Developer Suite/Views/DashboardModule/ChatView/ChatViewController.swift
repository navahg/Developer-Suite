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
    
    fileprivate static let messageDetailSegueIdentifier: String = "MessageDetail"
    
    // MARK: Properties
    var currentUser: UserMO!
    var chats: [ChatMO]!
    var selectedChatIndex: Int = -1
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
        self.currentUser = dashboardController.currentUser
        if let chats: [ChatMO] = dashboardController.currentUser.chats?.array as? [ChatMO] {
            for (index, _) in chats.enumerated() {
                var messages: [MessageMO] = chats[index].messages?.array as! [MessageMO]
                messages.sort(by: { firstMessage, secondMessage in
                    return (firstMessage.timestamp! as Date) < (secondMessage.timestamp! as Date)
                })
                chats[index].messages = NSOrderedSet(array: messages)
            }
            self.chats = chats.sorted(by: { firstChat, secondChat in
                guard let lastMessageInFirstChat: MessageMO = firstChat.messages?.array.last as? MessageMO else {
                    return false
                }
                
                guard let lastMessageInSecondChat: MessageMO = secondChat.messages?.array.last as? MessageMO else {
                    return true
                }
                
                return (lastMessageInFirstChat.timestamp! as Date) > (lastMessageInSecondChat.timestamp! as Date)
            })
        }
    }
}

// MARK: DashboardTabBarController delegates
extension ChatViewController: ChatDataDelegate {
    func didReceiveData(sender: DashboardTabBarController) {
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChatIndex = indexPath.row
        performSegue(withIdentifier: ChatViewController.messageDetailSegueIdentifier, sender: self)
    }
}

// MARK: Navigation Delegates
extension ChatViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == ChatViewController.messageDetailSegueIdentifier) {
            guard let messageDetail: ChatMessagesViewController = segue.destination as? ChatMessagesViewController else {
                Utils.log("TypeError: Unexpected destination type sent for MessageDetail segue.")
                return
            }
            
            guard let chatView: ChatViewController = sender as? ChatViewController else {
                Utils.log("TypeError: Unexpected sender type sent for MessageDetail segue.")
                return
            }
            
            guard chatView.selectedChatIndex >= 0 else {
                Utils.log("ValueError: Unexpected chat index is set in ChatViewController")
                return
            }
            
            if let selectedChat: ChatMO = chatView.chats?[selectedChatIndex] {
                messageDetail.chat = selectedChat
                messageDetail.sender = Sender(id: currentUser.uid!, displayName: currentUser.displayName!)
                messageDetail.receipient = Sender(id: selectedChat.recipientId!, displayName: selectedChat.recipientName!)
            }
        }
    }
}
