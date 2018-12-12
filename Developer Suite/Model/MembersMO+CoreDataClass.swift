//
//  MembersMO+CoreDataClass.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/12/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


public class MembersMO: NSManagedObject {
    // MARK: Convienience properties
    internal static let entityName: String = "Members"
    
    // MARK: Instance creator
    public class func getInstance(context: NSManagedObjectContext) -> MembersMO? {
        guard let _memberMO: MembersMO = NSEntityDescription.insertNewObject(forEntityName: MembersMO.entityName, into: context) as? MembersMO else {
            return nil
        }
        
        return _memberMO
    }
}
