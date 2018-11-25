//
//  MessageMO+CoreDataProperties.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/25/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageMO> {
        return NSFetchRequest<MessageMO>(entityName: "Messages")
    }

    @NSManaged public var message: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var isOutgoing: Bool
    @NSManaged public var chat: ChatMO?

}
