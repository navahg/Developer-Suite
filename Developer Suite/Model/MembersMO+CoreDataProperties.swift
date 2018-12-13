//
//  MembersMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


extension MembersMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MembersMO> {
        return NSFetchRequest<MembersMO>(entityName: "Members")
    }

    @NSManaged public var name: String?
    @NSManaged public var uid: String?
    @NSManaged public var team: TeamsMO?

}
