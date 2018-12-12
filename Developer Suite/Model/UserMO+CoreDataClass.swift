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
    public class func createInstance(fromFIRUser user: User?, withContext context: NSManagedObjectContext) -> UserMO? {
        guard
            let _user: User = user,
            let _email: String = _user.email,
            let _userMO: UserMO = NSEntityDescription.insertNewObject(forEntityName: UserMO.entityName, into: context) as? UserMO
            else {
                return nil
        }
        
        // Set the firebase user instance
        // Warning: Will be removed in the future
        _userMO._setFIRUserInstance(user: _user)
        _userMO.uid = _user.uid
        _userMO.displayName = _user.displayName ?? _email
        _userMO.email = _email
        
        if let providerInfo: UserInfo = _user.providerData.first, providerInfo.providerID == "github.com" {
            _userMO.githubId = providerInfo.uid
        }
        
        return _userMO
    }
    
    /**
     Getter method for the `_firbaseUserInstance` property
     - Returns: The FIRUser instance of the user
     */
    func _getFIRUserInstance() -> User? {
        return _firbaseUserInstance
    }
    
    /**
     Setter method for the `_firbaseUserInstance` property
     - Parameter user: The FIRUser instance of the user
     */
    func _setFIRUserInstance(user: User) {
        _firbaseUserInstance = user
    }
}
