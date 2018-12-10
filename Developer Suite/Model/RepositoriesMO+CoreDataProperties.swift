//
//  RepositoriesMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


extension RepositoriesMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoriesMO> {
        return NSFetchRequest<RepositoriesMO>(entityName: "Repositories")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var isPrivate: Bool
    @NSManaged public var url: String?
    @NSManaged public var isOwnedBySelf: Bool
    @NSManaged public var user: UserMO?
    @NSManaged public var branches: NSSet?

}

// MARK: Generated accessors for branches
extension RepositoriesMO {

    @objc(addBranchesObject:)
    @NSManaged public func addToBranches(_ value: BranchesMO)

    @objc(removeBranchesObject:)
    @NSManaged public func removeFromBranches(_ value: BranchesMO)

    @objc(addBranches:)
    @NSManaged public func addToBranches(_ values: NSSet)

    @objc(removeBranches:)
    @NSManaged public func removeFromBranches(_ values: NSSet)

}
