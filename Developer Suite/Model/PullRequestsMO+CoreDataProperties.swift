//
//  PullRequestsMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


extension PullRequestsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PullRequestsMO> {
        return NSFetchRequest<PullRequestsMO>(entityName: "PullRequests")
    }

    @NSManaged public var id: Int64
    @NSManaged public var number: Int32
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var creator: String?
    @NSManaged public var commentsURL: String?
    @NSManaged public var comments: NSSet?
    @NSManaged public var repository: RepositoriesMO?

}

// MARK: Generated accessors for comments
extension PullRequestsMO {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: PRCommentsMO)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: PRCommentsMO)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}
