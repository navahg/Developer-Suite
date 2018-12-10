//
//  BranchesMO+CoreDataProperties.swift
//  
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//
//

import Foundation
import CoreData


extension BranchesMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BranchesMO> {
        return NSFetchRequest<BranchesMO>(entityName: "Branches")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var repository: RepositoriesMO?

}
