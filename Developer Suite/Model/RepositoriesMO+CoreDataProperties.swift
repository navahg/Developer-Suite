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
    @NSManaged public var pullRequests: NSOrderedSet?

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

// MARK: Generated accessors for pullRequests
extension RepositoriesMO {

    @objc(insertObject:inPullRequestsAtIndex:)
    @NSManaged public func insertIntoPullRequests(_ value: PullRequestsMO, at idx: Int)

    @objc(removeObjectFromPullRequestsAtIndex:)
    @NSManaged public func removeFromPullRequests(at idx: Int)

    @objc(insertPullRequests:atIndexes:)
    @NSManaged public func insertIntoPullRequests(_ values: [PullRequestsMO], at indexes: NSIndexSet)

    @objc(removePullRequestsAtIndexes:)
    @NSManaged public func removeFromPullRequests(at indexes: NSIndexSet)

    @objc(replaceObjectInPullRequestsAtIndex:withObject:)
    @NSManaged public func replacePullRequests(at idx: Int, with value: PullRequestsMO)

    @objc(replacePullRequestsAtIndexes:withPullRequests:)
    @NSManaged public func replacePullRequests(at indexes: NSIndexSet, with values: [PullRequestsMO])

    @objc(addPullRequestsObject:)
    @NSManaged public func addToPullRequests(_ value: PullRequestsMO)

    @objc(removePullRequestsObject:)
    @NSManaged public func removeFromPullRequests(_ value: PullRequestsMO)

    @objc(addPullRequests:)
    @NSManaged public func addToPullRequests(_ values: NSOrderedSet)

    @objc(removePullRequests:)
    @NSManaged public func removeFromPullRequests(_ values: NSOrderedSet)

}
