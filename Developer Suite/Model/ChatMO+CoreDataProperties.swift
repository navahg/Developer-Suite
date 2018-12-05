//
//  ChatMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/25/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMO> {
        return NSFetchRequest<ChatMO>(entityName: "Chats")
    }

    @NSManaged public var id: String!
    @NSManaged public var recipientName: String?
    @NSManaged public var recipientId: String?
    @NSManaged public var messages: NSOrderedSet?
    @NSManaged public var owner: UserMO?

}

// MARK: Generated accessors for messages
extension ChatMO {

    @objc(insertObject:inMessagesAtIndex:)
    @NSManaged public func insertIntoMessages(_ value: MessageMO, at idx: Int)

    @objc(removeObjectFromMessagesAtIndex:)
    @NSManaged public func removeFromMessages(at idx: Int)

    @objc(insertMessages:atIndexes:)
    @NSManaged public func insertIntoMessages(_ values: [MessageMO], at indexes: NSIndexSet)

    @objc(removeMessagesAtIndexes:)
    @NSManaged public func removeFromMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInMessagesAtIndex:withObject:)
    @NSManaged public func replaceMessages(at idx: Int, with value: MessageMO)

    @objc(replaceMessagesAtIndexes:withMessages:)
    @NSManaged public func replaceMessages(at indexes: NSIndexSet, with values: [MessageMO])

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageMO)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageMO)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSOrderedSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSOrderedSet)

}
