//
//  ChatMessagesViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/6/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar

final class ChatMessagesViewController: BasicMessagesViewController {
    // MARK: - Properties
    var dashboardController: DashboardTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardController.messagesDelegate = self
    }

    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

// MARK: - Messages Delegate
extension ChatMessagesViewController: MessageDelegate {
    func didReceiveNewMessage(_ message: MessageMO) {
        if (message.chat?.id == chat.id && message.senderId == chat.recipientId) {
            let chatMessage: ChatMessage = ChatMessage(
                text: message.message ?? "",
                sender: message.senderId == sender.id ? sender : receipient,
                messageId: message.id,
                date: (message.timestamp ?? NSDate()) as Date)
            addNewReceivedMessage(chatMessage)
        }
    }
}

// MARK: - Messages Layout Delegate
extension ChatMessagesViewController: MessagesLayoutDelegate {
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

// MARK: - Messages Display Delegate
extension ChatMessagesViewController: MessagesDisplayDelegate {
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primaryColor : .secondaryColor
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar: Avatar = FirebaseService.shared.getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
    }
}
