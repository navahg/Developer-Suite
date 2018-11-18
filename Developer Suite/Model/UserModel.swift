//
//  UserModel.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 10/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation
import Firebase

/// The model for representing a User
class UserModel {
    // The user instance provided by firebase
    private let _firbaseUserInstance: User!
    
    // Display name of the user
    var displayName: String? {
        return _firbaseUserInstance?.displayName
    }
    
    // Unique identifier of the user
    var username: String? {
        return _firbaseUserInstance?.email
    }
    
    // UID of the user
    var uid: String? {
        return _firbaseUserInstance?.uid
    }
    
    /**
     The initializer that initializes using a FIRUser instance
     - Parameter fromFIRUser: The firebase user instance
     */
    init?(fromFIRUser user: User?) {
        guard let _firbaseUserInstance: User = user else {
            return nil
        }
        
        // Initialize all the stored property
        self._firbaseUserInstance = _firbaseUserInstance
    }
    
    /**
     The initializer for the User model
    */
    init() {
        self._firbaseUserInstance = nil
    }
    
    /**
     Getter method for the `_firbaseUserInstance` property
     - Returns: The FIRUser instance of the user
     */
    func getFIRUserInstance() -> User? {
        return _firbaseUserInstance
    }
}
