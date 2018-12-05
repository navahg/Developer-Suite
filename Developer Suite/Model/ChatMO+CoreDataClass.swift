//
//  ChatMO+CoreDataClass.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/25/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


public class ChatMO: NSManagedObject {
    
    // MARK: Convienience properties
    internal static let entityName: String = "Chats"

    // MARK: Instance creator
    public class func getInstance(context: NSManagedObjectContext) -> ChatMO? {
        guard let _chatMO: ChatMO = NSEntityDescription.insertNewObject(forEntityName: ChatMO.entityName, into: context) as? ChatMO else {
            return nil
        }
        
        return _chatMO
    }
}
