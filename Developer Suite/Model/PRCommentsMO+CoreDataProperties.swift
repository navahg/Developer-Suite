//
//  PRCommentsMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


extension PRCommentsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PRCommentsMO> {
        return NSFetchRequest<PRCommentsMO>(entityName: "PRComments")
    }

    @NSManaged public var body: String?
    @NSManaged public var creator: String?
    @NSManaged public var id: Int64
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var pullRequest: PullRequestsMO?

}
