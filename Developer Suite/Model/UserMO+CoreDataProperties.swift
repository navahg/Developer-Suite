//
//  UserMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/25/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


extension UserMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: UserMO.entityName)
    }

    @NSManaged public var displayName: String?
    @NSManaged public var isLoggedIn: Bool
    @NSManaged public var uid: String?
    @NSManaged public var email: String?
    @NSManaged public var chats: NSOrderedSet?

}

// MARK: Generated accessors for chats
extension UserMO {

    @objc(insertObject:inChatsAtIndex:)
    @NSManaged public func insertIntoChats(_ value: ChatMO, at idx: Int)

    @objc(removeObjectFromChatsAtIndex:)
    @NSManaged public func removeFromChats(at idx: Int)

    @objc(insertChats:atIndexes:)
    @NSManaged public func insertIntoChats(_ values: [ChatMO], at indexes: NSIndexSet)

    @objc(removeChatsAtIndexes:)
    @NSManaged public func removeFromChats(at indexes: NSIndexSet)

    @objc(replaceObjectInChatsAtIndex:withObject:)
    @NSManaged public func replaceChats(at idx: Int, with value: ChatMO)

    @objc(replaceChatsAtIndexes:withChats:)
    @NSManaged public func replaceChats(at indexes: NSIndexSet, with values: [ChatMO])

    @objc(addChatsObject:)
    @NSManaged public func addToChats(_ value: ChatMO)

    @objc(removeChatsObject:)
    @NSManaged public func removeFromChats(_ value: ChatMO)

    @objc(addChats:)
    @NSManaged public func addToChats(_ values: NSOrderedSet)

    @objc(removeChats:)
    @NSManaged public func removeFromChats(_ values: NSOrderedSet)

}
