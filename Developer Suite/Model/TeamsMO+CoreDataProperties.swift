//
//  TeamsMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/12/18.
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
    @NSManaged public var members: NSSet?
    @NSManaged public var user: UserMO?

}

// MARK: Generated accessors for members
extension TeamsMO {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: MembersMO)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: MembersMO)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}
