//
//  BranchesMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
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
