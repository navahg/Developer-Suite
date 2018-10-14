//
//  UserModel.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 10/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation

/// The model for representing a User
class User {
    // The id for this user
    private let _id: Int
    
    // First name of the user
    private var firstName: String
    
    // Last name of the user
    private var lastName: String
    
    // Unique identifier of the user
    private var username: String
    
    /**
     The initializer that initializes using a dictionary
     - Parameter fromDictionary: The dictionary that contains value for all the properties
     */
    init?(fromDictionary dictionary: [String: Any]) {
        guard
            let _id: Int = dictionary["_id"] as? Int,
            let username: String = dictionary["username"] as? String,
            let firstName: String = dictionary["firstName"] as? String,
            let lastName: String = dictionary["lastName"] as? String
        else {
            return nil
        }
        
        // Initialize all the stored property
        self._id = _id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
    }
    
    /**
     The initializer for the User model
     - Parameter withID: The id of this user
     - Parameter andFirstName: The first name of the user
     - Parameter andLastName: The last name of the user
     - Parameter andUserName: The unique identifier for the user
    */
    init(withID _id: Int, andFirstName firstName: String, andLastName lastName: String, andUsername username: String) {
        self._id = _id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
    }
    
    /**
     This converts the whole instance into a dictionary
     - Returns: The stored properties in a dictionary format
     */
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = Dictionary<String, Any>()
        
        dictionary["_id"] = _id
        dictionary["username"] = username
        dictionary["firstName"] = firstName
        dictionary["lastName"] = lastName
        
        return dictionary
    }
    
    /**
     This sets the value of the first name
     - Parameter firstName: The new value of firstname that has to be updated
    */
    func set(firstName: String) {
        self.firstName = firstName
    }
    
    /**
     This sets the value of the last name
     - Parameter lastName: The new value of lastname that has to be updated
     */
    func set(lastName: String) {
        self.lastName = lastName
    }
    
    /**
     This sets the value of the unique identifier
     - Parameter username: The new value of unique identifier that has to be updated
     */
    func set(username: String) {
        self.username = username
    }
    
    /**
     Getter method for the `_id` property
     - Returns: The id of the user
     */
    func getId() -> Int {
        return _id
    }
    
    /**
     Getter method for the `firstName` property
     - Returns: The firstname of the user
     */
    func getFirstName() -> String {
        return firstName
    }
    
    /**
     Getter method for the `lastName` property
     - Returns: The lastname of the user
     */
    func getLastName() -> String {
        return lastName
    }
    
    /**
     Getter method for the `username` property
     - Returns: The unique identifier of the user
     */
    func getUsername() -> String {
        return username
    }
}
