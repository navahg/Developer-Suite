//
//  UserFetchRequest.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/4/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation
import CoreData

final class UserFetchRequest {
    public class func fetchUser(withUID uid: String) throws -> UserMO? {
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "uid == %@", uid)
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let users: [UserMO] = try DataManager.shared.context.fetch(fetchRequest)
        
        if users.isEmpty {
            return nil
        } else {
            return users.first
        }
    }
}
