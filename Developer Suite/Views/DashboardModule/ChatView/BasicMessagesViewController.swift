//
//  MessagesViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/6/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation
import MessageKit
import MessageInputBar

class BasicMessagesViewController: MessagesViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Properties
    var chat: ChatMO!
    var sender: Sender!
    var receipient: Sender!
    var messages: [MessageType] = []
    
    // MARK: Helper properties
    let formatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageCollectionView()
        configureMessageInputBar()
        loadMessages()
        
        title = chat?.recipientName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesCollectionView.scrollToBottom(animated: false)
    }
    
    private func loadMessages() {
        for message in chat.messages?.array ?? [] {
            let messageMO: MessageMO = message as! MessageMO
            let messageType: MessageType = ChatMessage(
                text: messageMO.message ?? "",
                sender: messageMO.senderId == sender.id ? sender : receipient,
                messageId: messageMO.id!,
                date: (messageMO.timestamp ?? NSDate()) as Date)
            messages.append(messageType)
        }
    }
    
    // MARK: Configuring MessageKit
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.sendButton.tintColor = .primaryColor
    }
}

// MARK: - Messages data source
extension BasicMessagesViewController: MessagesDataSource {
    func currentSender() -> Sender {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

// MARK: - MessageInputBarDelegate
extension BasicMessagesViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        for component in inputBar.inputTextView.components {
            if let str = component as? String {
                FirebaseService.shared.addMessage(
                    str,
                    forChat: chat, andSender: sender) { messageID in
                        if messageID == nil {
                            Utils.log("Cannot send message.")
                            DispatchQueue.main.async {
                                self.present(
                                    Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Cannot send the message."),
                                    animated: true,
                                    completion: nil)
                            }
                            return
                        }
                        
                        let message = ChatMessage(
                            text: str,
                            sender: self.currentSender(),
                            messageId: messageID!,
                            date: Date())
                        self.insertMessage(message)
                        inputBar.inputTextView.text = String()
                        self.messagesCollectionView.scrollToBottom(animated: true)
                }
            }
        }
    }
    
}

// MARK: - Helpers
extension BasicMessagesViewController {
    func insertMessage(_ message: ChatMessage) {
        // Create MessageMO Object
        guard let messageMO: MessageMO = MessageMO.getInstance(context: DataManager.shared.context) else {
            return
        }
        messageMO.chat = chat
        switch message.kind {
        case .text(let value):
            messageMO.message = value
        default:
            messageMO.message = nil
        }
        messageMO.timestamp = message.sentDate as NSDate
        messageMO.id = message.messageId
        messageMO.senderId = message.sender.id
        
        // Adding message to chats
        chat.addToMessages(messageMO)
        
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func addNewReceivedMessage(_ message: ChatMessage) {
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        guard !messages.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
}
