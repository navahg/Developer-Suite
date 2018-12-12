//
//  RepositoriesMO+CoreDataClass.swift
//  
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//
//

import Foundation
import CoreData


public class RepositoriesMO: NSManagedObject {
    // MARK: Convienience properties
    internal static let entityName: String = "Repositories"
    
    // MARK: Instance creator
    public class func getInstance(context: NSManagedObjectContext) -> RepositoriesMO? {
        guard let _repositoryMO: RepositoriesMO = NSEntityDescription.insertNewObject(forEntityName: RepositoriesMO.entityName, into: context) as? RepositoriesMO else {
            return nil
        }
        
        return _repositoryMO
    }
}
