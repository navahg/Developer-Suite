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
    
    public var currentUser: UserMO?
    
    // Mark: Private Methods
    private override init() {}
    
    private func fetchUser(withUID uid: String) throws -> UserMO? {
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "uid == %@", uid)
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let users: [UserMO] = try context.fetch(fetchRequest)
        
        if users.isEmpty {
            return nil
        } else {
            return users.first
        }
    }
    
    // Mark: Public methods
    public func createUser(_ user: User) throws -> UserMO {
        do {
            if let _user: UserMO = try fetchUser(withUID: user.uid) {
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
