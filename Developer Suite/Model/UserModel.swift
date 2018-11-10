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
    private let _firbaseUserInstance: User?
    
    // Display name of the user
    private var displayName: String?
    
    // Unique identifier of the user
    private var username: String?
    
    /**
     The initializer that initializes using a FIRUser instance
     - Parameter fromFIRUser: The firebase user instance
     */
    init?(fromFIRUser user: User?) {
        guard
            let _firbaseUserInstance: User = user,
            let username: String = user?.email,
            let displayName: String = user?.displayName
        else {
            return nil
        }
        
        // Initialize all the stored property
        self._firbaseUserInstance = _firbaseUserInstance
        self.username = username
        self.displayName = displayName
    }
    
    /**
     The initializer for the User model
    */
    init() {
        self._firbaseUserInstance = nil
        self.displayName = nil
        self.username = nil
    }
    
    /**
     This sets the value of the displayName name
     - Parameter displayName: The new value of display name that has to be updated
     */
    func set(displayName: String) {
        self.displayName = displayName
    }
    
    /**
     This sets the value of the unique identifier
     - Parameter username: The new value of unique identifier that has to be updated
     */
    func set(username: String) {
        self.username = username
    }
    
    /**
     Getter method for the `_firbaseUserInstance` property
     - Returns: The FIRUser instance of the user
     */
    func getFIRUserInstance() -> User? {
        return _firbaseUserInstance
    }
    
    /**
     Getter method for the `displayName` property
     - Returns: The display name of the user
     */
    func getDisplayName() -> String? {
        return displayName
    }
    
    /**
     Getter method for the `username` property
     - Returns: The unique identifier of the user
     */
    func getUsername() -> String? {
        return username
    }
}
