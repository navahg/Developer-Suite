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
    
    // MARK: Properties
    public var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    // Mark: Private Methods
    private override init() {}
    
    // Mark: Public methods
    public func createUser(_ user: User) throws -> UserMO {
        guard let newUser: UserMO = UserMO(fromFIRUser: user, withContext: context) else {
            throw CoreDataError.insertionFailed
        }
        
        return newUser
    }
}
