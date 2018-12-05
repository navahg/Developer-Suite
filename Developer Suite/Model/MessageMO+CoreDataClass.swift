//
//  MessageMO+CoreDataClass.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/25/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


public class MessageMO: NSManagedObject {
    // MARK: Convienience properties
    internal static let entityName: String = "Messages"
    
    // MARK: Instance creator
    public class func getInstance(context: NSManagedObjectContext) -> MessageMO? {
        guard let _messageMO: MessageMO = NSEntityDescription.insertNewObject(forEntityName: MessageMO.entityName, into: context) as? MessageMO else {
            return nil
        }
        
        return _messageMO
    }
}
