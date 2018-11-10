//
//  UserModelTests.swift
//  Developer SuiteTests
//
//  Created by RAGHAVAN RENGANATHAN on 10/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import XCTest
@testable import Developer_Suite

class UserModelTests: XCTestCase {

    // MARK: Unit test cases for the User model
    
    // User model should create an instance with the sent values for stored properties
    func testModelCreationBySendingValuesForStoredProperties() {
        let testUser: User = User(withID: 1, andFirstName: "John", andLastName: "Doe", andUsername: "john_doe")
        
        XCTAssertNoThrow(testUser, "An User instance should be created, but instead it is nil")
    }
    
    // This tests creation of an instance using a dictionary
    func testCreateModelUsingDictionary() {
        let testUser: User?
        var dictionary: [String: Any] = Dictionary<String, Any>()
        
        dictionary["_id"] = 1
        dictionary["username"] = "john.doe"
        dictionary["firstName"] = "John"
        dictionary["lastName"] = "Doe"
        
        testUser = User(fromDictionary: dictionary)
        
        XCTAssertNotNil(testUser, "An User instance should be created, but instead it is nil")
    }
    
    // Tests creation of instance when invalid data is sent
    func testCreationOfInstanceWhenInvalidDataIsSent() {
        let testUser: User?
        var dictionary: [String: Any] = Dictionary<String, Any>()
        
        dictionary["_id"] = "id" // This is not expected
        dictionary["username"] = "john.doe"
        dictionary["firstName"] = "John"
        dictionary["lastName"] = "Doe"
        
        testUser = User(fromDictionary: dictionary)
        
        XCTAssertNil(testUser, "An User instance should be nil")
    }
    
    // Tests when one data is missing
    func testCreationOfInstanceWhenDataIsNotSent() {
        let testUser: User?
        var dictionary: [String: Any] = Dictionary<String, Any>()
        
        dictionary["_id"] = "id" // This is not expected
        dictionary["username"] = "john.doe"
        dictionary["lastName"] = "Doe"
        
        testUser = User(fromDictionary: dictionary)
        
        XCTAssertNil(testUser, "An User instance should be nil")
    }
    
    // The instance should store and persist all the sent values for stored properties
    func testModelToPersistTheSentValues() {
        let testUser: User = User(withID: 1, andFirstName: "John", andLastName: "Doe", andUsername: "john_doe")

        XCTAssertEqual(testUser.getId(), 1)
        XCTAssertEqual(testUser.getUsername(), "john_doe")
        XCTAssertEqual(testUser.getFirstName(), "John")
        XCTAssertEqual(testUser.getLastName(), "Doe")
    }

    // The first name should be updated using the set method with firstname parameter
    func testUpdatingFirstName() {
        let testUser: User = User(withID: 1, andFirstName: "John", andLastName: "Doe", andUsername: "john_doe")
        
        XCTAssertEqual(testUser.getFirstName(), "John")
        testUser.set(firstName: "Jane")
        XCTAssertEqual(testUser.getFirstName(), "Jane")
    }
    
    // The last name should be updated using the set method with lastname parameter
    func testUpdatingLastName() {
        let testUser: User = User(withID: 1, andFirstName: "John", andLastName: "Doe", andUsername: "john_doe")
        
        XCTAssertEqual(testUser.getLastName(), "Doe")
        testUser.set(lastName: "Tuner")
        XCTAssertEqual(testUser.getLastName(), "Tuner")
    }
    
    // The username should be updated using the set method with username parameter
    func testUpdatingUsername() {
        let testUser: User = User(withID: 1, andFirstName: "John", andLastName: "Doe", andUsername: "john_doe")
        
        XCTAssertEqual(testUser.getUsername(), "john_doe")
        testUser.set(username: "john.doe")
        XCTAssertEqual(testUser.getUsername(), "john.doe")
    }

}
