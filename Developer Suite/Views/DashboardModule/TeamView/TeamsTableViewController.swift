//
//  TeamsTableViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/12/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import MessageKit

class TeamsTableViewController: UITableViewController {
    
    // MARK: Static Properties
    private static let startMessageSegue: String = "messageDetailFromTeams"
    
    // MARK: Properties
    var user: UserMO!
    var teams: [TeamsMO]!
    var dashboardController: DashboardTabBarController!
    
    var chatForSelectedMember: ChatMO? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardController = self.tabBarController as? DashboardTabBarController
        dashboardController.teamsDelegate = self
        
        loadData()
    }

    private func loadData() {
        user = dashboardController.currentUser
        teams = (user.team?.array ?? []) as? [TeamsMO] ?? []
        tableView.reloadData()
    }
    
    // MARK: Handlers
    private func startChat(withMember member: MembersMO) {
        // check if there are existing chat for this user
        if let chatOrNil: ChatMO? = try? ChatsFetchRequest.fetchChat(withReceipientID: member.uid!),
            let existingChat: ChatMO = chatOrNil {
            chatForSelectedMember = existingChat
            self.performSegue(withIdentifier: TeamsTableViewController.startMessageSegue, sender: self)
        } else {
            FirebaseService.shared.addChat(senderID: user.uid!, receipientID: member.uid!) { chatID in
                if (chatID == nil) {
                    self.present(
                        Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Cannot start chat"),
                        animated: true,
                        completion: nil)
                    return
                }
                
                guard let newChat: ChatMO = ChatMO.getInstance(context: DataManager.shared.context) else {
                    Utils.log("CoreDataError: Unable to create an instance for Chats")
                    self.present(
                        Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Cannot start chat"),
                        animated: true,
                        completion: nil)
                    return
                }
                newChat.id = chatID!
                newChat.recipientId = member.uid
                newChat.recipientName = member.name
                newChat.owner = self.user
                self.user.addToChats(newChat)
                self.chatForSelectedMember = newChat
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: TeamsTableViewController.startMessageSegue, sender: self)
                }
            }
        }
    }
}

// MARK: - Table view delegates
extension TeamsTableViewController {
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let chat: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Message") { action, indexPath in
            if let member: MembersMO = self.teams[indexPath.section].members?.array[indexPath.row] as? MembersMO {
                self.startChat(withMember: member)
            }
        }
        chat.backgroundColor = .primaryColor
        
        return [chat]
    }
}

// MARK: - Table view data source
extension TeamsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return teams[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams[section].members?.array.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MemberTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: MemberTableViewCell.identifier,
            for: indexPath) as? MemberTableViewCell else {
                fatalError("This cell is not of expected type: MemberTableViewCell")
        }
        let team: TeamsMO = teams[indexPath.section]
        let member: MembersMO? = team.members?.array[indexPath.row] as? MembersMO
        
        // Configure the cell...
        cell.displayNameLabel.text = member?.name
        cell.member = member
        
        return cell
    }
}

// MARK: DashboardTabBarController delegates
extension TeamsTableViewController: TeamDataDeleagte {
    func didReceiveData(sender: DashboardTabBarController) {
        loadData()
    }
}

// MARK: Navigation Delegates
extension TeamsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == TeamsTableViewController.startMessageSegue) {
            guard let messageDetail: ChatMessagesViewController = segue.destination as? ChatMessagesViewController else {
                Utils.log("TypeError: Unexpected destination type sent for MessageDetail segue.")
                return
            }
            
            guard let chat: ChatMO = chatForSelectedMember else {
                Utils.log("TypeError: Found Nil when unwrapping member and chat")
                return
            }
            
            messageDetail.chat = chat
            messageDetail.sender = Sender(id: user.uid!, displayName: user.displayName!)
            messageDetail.receipient = Sender(id: chat.recipientId!, displayName: chat.recipientName!)
            messageDetail.dashboardController = dashboardController
        }
    }
}
