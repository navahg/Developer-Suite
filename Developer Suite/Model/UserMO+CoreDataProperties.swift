//
//  UserMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/12/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "Users")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var email: String?
    @NSManaged public var githubId: String?
    @NSManaged public var isLoggedIn: Bool
    @NSManaged public var uid: String?
    @NSManaged public var chats: NSOrderedSet?
    @NSManaged public var repositories: NSOrderedSet?
    @NSManaged public var team: NSOrderedSet?

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

// MARK: Generated accessors for repositories
extension UserMO {

    @objc(insertObject:inRepositoriesAtIndex:)
    @NSManaged public func insertIntoRepositories(_ value: RepositoriesMO, at idx: Int)

    @objc(removeObjectFromRepositoriesAtIndex:)
    @NSManaged public func removeFromRepositories(at idx: Int)

    @objc(insertRepositories:atIndexes:)
    @NSManaged public func insertIntoRepositories(_ values: [RepositoriesMO], at indexes: NSIndexSet)

    @objc(removeRepositoriesAtIndexes:)
    @NSManaged public func removeFromRepositories(at indexes: NSIndexSet)

    @objc(replaceObjectInRepositoriesAtIndex:withObject:)
    @NSManaged public func replaceRepositories(at idx: Int, with value: RepositoriesMO)

    @objc(replaceRepositoriesAtIndexes:withRepositories:)
    @NSManaged public func replaceRepositories(at indexes: NSIndexSet, with values: [RepositoriesMO])

    @objc(addRepositoriesObject:)
    @NSManaged public func addToRepositories(_ value: RepositoriesMO)

    @objc(removeRepositoriesObject:)
    @NSManaged public func removeFromRepositories(_ value: RepositoriesMO)

    @objc(addRepositories:)
    @NSManaged public func addToRepositories(_ values: NSOrderedSet)

    @objc(removeRepositories:)
    @NSManaged public func removeFromRepositories(_ values: NSOrderedSet)

}

// MARK: Generated accessors for team
extension UserMO {

    @objc(insertObject:inTeamAtIndex:)
    @NSManaged public func insertIntoTeam(_ value: TeamsMO, at idx: Int)

    @objc(removeObjectFromTeamAtIndex:)
    @NSManaged public func removeFromTeam(at idx: Int)

    @objc(insertTeam:atIndexes:)
    @NSManaged public func insertIntoTeam(_ values: [TeamsMO], at indexes: NSIndexSet)

    @objc(removeTeamAtIndexes:)
    @NSManaged public func removeFromTeam(at indexes: NSIndexSet)

    @objc(replaceObjectInTeamAtIndex:withObject:)
    @NSManaged public func replaceTeam(at idx: Int, with value: TeamsMO)

    @objc(replaceTeamAtIndexes:withTeam:)
    @NSManaged public func replaceTeam(at indexes: NSIndexSet, with values: [TeamsMO])

    @objc(addTeamObject:)
    @NSManaged public func addToTeam(_ value: TeamsMO)

    @objc(removeTeamObject:)
    @NSManaged public func removeFromTeam(_ value: TeamsMO)

    @objc(addTeam:)
    @NSManaged public func addToTeam(_ values: NSOrderedSet)

    @objc(removeTeam:)
    @NSManaged public func removeFromTeam(_ values: NSOrderedSet)

}
