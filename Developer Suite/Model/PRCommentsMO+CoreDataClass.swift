//
//  PRComments+CoreDataClass.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PRComments)
public class PRCommentsMO: NSManagedObject {
    // MARK: Convienience properties
    internal static let entityName: String = "PRComments"
    
    // MARK: Instance creator
    public class func getInstance(context: NSManagedObjectContext) -> PRCommentsMO? {
        guard let _prComment: PRCommentsMO = NSEntityDescription.insertNewObject(forEntityName: PRCommentsMO.entityName, into: context) as? PRCommentsMO else {
            return nil
        }
        
        return _prComment
    }
}
