//
//  ChatsFetchRequest.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/4/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation
import CoreData

final class ChatsFetchRequest {
    public class func fetchChat(withID id: String) throws -> ChatMO? {
        let fetchRequest: NSFetchRequest<ChatMO> = ChatMO.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "id == %@", id)
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let chats: [ChatMO] = try DataManager.shared.context.fetch(fetchRequest)
        
        if chats.isEmpty {
            return nil
        } else {
            return chats.first
        }
    }
    
    public class func fetchChat(withReceipientID id: String) throws -> ChatMO? {
        let fetchRequest: NSFetchRequest<ChatMO> = ChatMO.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "recipientId == %@", id)
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let chats: [ChatMO] = try DataManager.shared.context.fetch(fetchRequest)
        
        if chats.isEmpty {
            return nil
        } else {
            return chats.first
        }
    }
}
