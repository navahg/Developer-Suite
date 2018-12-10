//
//  PullRequests+CoreDataClass.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PullRequests)
public class PullRequestsMO: NSManagedObject {
    // MARK: Convienience properties
    internal static let entityName: String = "PullRequests"
    
    // MARK: Instance creator
    public class func getInstance(context: NSManagedObjectContext) -> PullRequestsMO? {
        guard let _pullRequestMO: PullRequestsMO = NSEntityDescription.insertNewObject(forEntityName: PullRequestsMO.entityName, into: context) as? PullRequestsMO else {
            return nil
        }
        
        return _pullRequestMO
    }
}
