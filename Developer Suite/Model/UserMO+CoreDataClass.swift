//
//  UserMO+CoreDataClass.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/25/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//
//

import Foundation
import Firebase
import CoreData

public class UserMO: NSManagedObject {
    // The entity name of this NSManagedObject
    internal static let entityName: String = "Users"
    
    // The user instance provided by firebase
    private var _firbaseUserInstance: User!
    
    /**
     The initializer that initializes using a FIRUser instance
     - Parameter fromFIRUser: The firebase user instance
     */
    convenience init?(fromFIRUser user: User?, withContext context: NSManagedObjectContext) {
        guard
            let _user: User = user,
            let _email: String = _user.email,
            let _entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: UserMO.entityName, in: context)
            else {
                return nil
        }
        
        self.init(
            uid: _user.uid,
            displayName: _user.displayName ?? _email,
            email: _email,
            entity: _entity,
            context: context)
        // Set the firebase user instance
        // Warning: Will be removed in the future
        self._firbaseUserInstance = _user
    }
    
    /**
     The initializer for the User model
     */
    private init(uid: String, displayName: String, email: String, entity: NSEntityDescription, context: NSManagedObjectContext) {
        super.init(
            entity: entity,
            insertInto: context)
        
        // Set all the members
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.isLoggedIn = true
    }
    
    /**
     Getter method for the `_firbaseUserInstance` property
     - Returns: The FIRUser instance of the user
     */
    func getFIRUserInstance() -> User? {
        return _firbaseUserInstance
    }
}
