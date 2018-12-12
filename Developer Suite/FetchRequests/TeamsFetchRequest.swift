//
//  TeamsFetchRequest.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/12/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation
import CoreData

final class TeamsFetchRequest {
    public class func fetchTeam(withID id: String) throws -> TeamsMO? {
        let fetchRequest: NSFetchRequest<TeamsMO> = TeamsMO.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "id == %@", id)
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let teams: [TeamsMO] = try DataManager.shared.context.fetch(fetchRequest)
        
        if teams.isEmpty {
            return nil
        } else {
            return teams.first
        }
    }
}
