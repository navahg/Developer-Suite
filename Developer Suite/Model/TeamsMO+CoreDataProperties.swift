//
//  TeamsMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


extension TeamsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamsMO> {
        return NSFetchRequest<TeamsMO>(entityName: "Teams")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var members: NSOrderedSet?
    @NSManaged public var user: UserMO?

}

// MARK: Generated accessors for members
extension TeamsMO {

    @objc(insertObject:inMembersAtIndex:)
    @NSManaged public func insertIntoMembers(_ value: MembersMO, at idx: Int)

    @objc(removeObjectFromMembersAtIndex:)
    @NSManaged public func removeFromMembers(at idx: Int)

    @objc(insertMembers:atIndexes:)
    @NSManaged public func insertIntoMembers(_ values: [MembersMO], at indexes: NSIndexSet)

    @objc(removeMembersAtIndexes:)
    @NSManaged public func removeFromMembers(at indexes: NSIndexSet)

    @objc(replaceObjectInMembersAtIndex:withObject:)
    @NSManaged public func replaceMembers(at idx: Int, with value: MembersMO)

    @objc(replaceMembersAtIndexes:withMembers:)
    @NSManaged public func replaceMembers(at indexes: NSIndexSet, with values: [MembersMO])

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: MembersMO)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: MembersMO)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSOrderedSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSOrderedSet)

}
