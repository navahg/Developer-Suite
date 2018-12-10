//
//  BranchesMO+CoreDataClass.swift
//  
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//
//

import Foundation
import CoreData


public class BranchesMO: NSManagedObject {
    // MARK: Convienience properties
    internal static let entityName: String = "Branches"
    
    // MARK: Instance creator
    public class func getInstance(context: NSManagedObjectContext) -> BranchesMO? {
        guard let _branchMO: BranchesMO = NSEntityDescription.insertNewObject(forEntityName: BranchesMO.entityName, into: context) as? BranchesMO else {
            return nil
        }
        
        return _branchMO
    }
}
