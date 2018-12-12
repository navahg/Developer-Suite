//
//  DataManager.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/25/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Firebase
import CoreData

class DataManager: AppDelegate {
    // Making the class singleton
    public class var shared: DataManager {
        struct DataManagerInstance {
            static let instance: DataManager = DataManager()
        }
        return DataManagerInstance.instance
    }
    
    private override init() {}
    
    // MARK: Properties
    public var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    // Mark: Public methods
    public func createUser(_ user: User) throws -> UserMO {
        do {
            if let _user: UserMO = try UserFetchRequest.fetchUser(withUID: user.uid) {
                // If the user already exists in the core data
                // Return the user and do not create a new record
                return _user
            }
        } catch {
            throw CoreDataError.fetchFailed
        }
        
        guard let newUser: UserMO = UserMO.createInstance(fromFIRUser: user, withContext: context) else {
            throw CoreDataError.insertionFailed
        }
        
        return newUser
    }
}
