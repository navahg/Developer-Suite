//
//  TeamsMO+CoreDataClass.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/12/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


public class TeamsMO: NSManagedObject {
    // MARK: Convienience properties
    internal static let entityName: String = "Teams"
    
    // MARK: Instance creator
    public class func getInstance(context: NSManagedObjectContext) -> TeamsMO? {
        guard let _teamMO: TeamsMO = NSEntityDescription.insertNewObject(forEntityName: TeamsMO.entityName, into: context) as? TeamsMO else {
            return nil
        }
        
        return _teamMO
    }
}
