//
//  ChatViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/18/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController {
    
    // Mark: Properties
    private let ANONYMOUS_DISPLAY_NAME: String = "Anonymous"
    
    var messages: [MessageType] = []
    var user: UserModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}


// MARK: Message Data Source
extension ChatViewController: MessagesDataSource {
    func currentSender() -> Sender {
        return Sender(id: (user.uid)!, displayName: user.displayName ?? ANONYMOUS_DISPLAY_NAME)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

// MARK: Message Layout Delegate
extension ChatViewController: MessagesLayoutDelegate {
    // Defaults can be overriden here.
}

// MARK: Message Display Delegates
extension ChatViewController: MessagesDisplayDelegate {
    // Defaults can be overriden here.
}
