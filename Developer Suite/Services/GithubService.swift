//
//  GithubService.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/9/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation

final class GithubService {
    // MARK: Properties
    public class var shared: GithubService {
        struct GithubServiceInstance {
            static let instance: GithubService = GithubService()
        }
        return GithubServiceInstance.instance
    }
    
    fileprivate static let apiURL: String = "https://api.github.com"
    
    fileprivate let clientID: String?
    fileprivate let clientSecret: String?
    
    private init() {
        let Config: [String: Any]? = NSDictionary(contentsOfFile: Utils.ConfigFilePath!) as? [String: Any]
        clientID = Config?["GITHUB_CLIENT_ID"] as? String
        clientSecret = Config?["GITHUB_CLIENT_SECRET"] as? String
    }
}

// MARK: Fetch requests
extension GithubService {
    /**
     Fetches information about the user
     - Parameter id: The github user id for the user
     - Parameter completion: The closure to be called with the user data
     */
    public func getUserInfo(forUID id: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let url: String = "\(GithubService.apiURL)/user/\(id)"
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = "get"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let session: URLSession = URLSession(configuration: .default)
        let task: URLSessionTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                Utils.log("GITHUB_ERROR: Fetching auth user failed")
                completion(nil, HTTPError.requestFailed)
                return
            }
            
            guard let data: Data = data else {
                Utils.log("GITHUB_ERROR: No data received when tried to fetch auth user")
                completion(nil, HTTPError.noDataReceived)
                return
            }
            
            guard let responseJSON: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] else {
                Utils.log("Response is not a valid JSON.")
                completion(nil, HTTPError.notValidJSON)
                return
            }
            
            completion(responseJSON, nil)
        }
        
        task.resume()
    }
    
    /**
     Fetches repositories of the user
     - Parameter id: The github user id for the user
     - Parameter completion: The closure to be called with the user data
     */
    public func getUserRepos(forUID id: String, completion: @escaping ([RepositoriesMO]?, Error?) -> Void) {
        let url: String = "\(GithubService.apiURL)/user/\(id)/repos"
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = "get"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let session: URLSession = URLSession(configuration: .default)
        let task: URLSessionTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                Utils.log("GITHUB_ERROR: Fetching auth user failed")
                completion(nil, HTTPError.requestFailed)
                return
            }
            
            guard let data: Data = data else {
                Utils.log("GITHUB_ERROR: No data received when tried to fetch auth user")
                completion(nil, HTTPError.noDataReceived)
                return
            }
            
            guard let responseJSONOrNil: [[String: Any]]? = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                let responseJSON: [[String: Any]] = responseJSONOrNil
            else {
                Utils.log("Response is not a valid JSON.")
                completion(nil, HTTPError.notValidJSON)
                return
            }
            
            var repositories: [RepositoriesMO] = []
            let group: DispatchGroup = DispatchGroup()
            for repoData in responseJSON {
                group.enter()
                guard let repo: RepositoriesMO = RepositoriesMO.getInstance(context: DataManager.shared.context) else {
                    Utils.log("CoreDataError: Unable to insert object")
                    continue
                }
                repositories.append(repo)
                repo.id = repoData["id"] as? Int64 ?? -1
                repo.name = repoData["name"] as? String ?? "NA"
                repo.url = repoData["url"] as? String
                
                if let owner: [String: Any] = repoData["owner"] as? [String: Any],
                    let ownerId: Int64 = owner["id"] as? Int64 {
                    repo.isOwnedBySelf = ("\(ownerId)" == id)
                }
                
                self.getBranches(forRepo: repo) { branches, error in
                    if error != nil || branches == nil {
                        repo.branches = nil
                        group.leave()
                        return
                    }
                    
                    repo.branches = NSSet(array: branches!)
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(repositories, nil)
            }
        }
        task.resume()
    }
    
    /**
     Fetches information about the branches for a given user login id and repo name
     - Parameter id: The github user id for the user
     - Parameter completion: The closure to be called with the user data
     */
    public func getBranches(forRepo repo: RepositoriesMO, completion: @escaping ([BranchesMO]?, Error?) -> Void) {
        guard let repoURL: String = repo.url else {
            completion(nil, IllegalArguments.foundNilWhenUnwrapping)
            return
        }
        let url: String = "\(repoURL)/branches"
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = "get"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let session: URLSession = URLSession(configuration: .default)
        let task: URLSessionTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                Utils.log("GITHUB_ERROR: Fetching auth user failed")
                completion(nil, HTTPError.requestFailed)
                return
            }
            
            guard let data: Data = data else {
                Utils.log("GITHUB_ERROR: No data received when tried to fetch auth user")
                completion(nil, HTTPError.noDataReceived)
                return
            }
            
            guard let responseJSONOrNil: [[String: Any]]? = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                let responseJSON: [[String: Any]] = responseJSONOrNil
            else {
                Utils.log("Response is not a valid JSON.")
                completion(nil, HTTPError.notValidJSON)
                return
            }
            
            var branches: [BranchesMO] = []
            for branchData in responseJSON {
                guard let branch: BranchesMO = BranchesMO.getInstance(context: DataManager.shared.context) else {
                    Utils.log("CoreDataError: Unable to insert object")
                    continue
                }
                branch.name = branchData["name"] as? String
                branch.url = branch.name != nil ? "\(repoURL)/branches/\(branch.name!)" : nil
                branch.repository = repo
                
                branches.append(branch)
            }
            
            completion(branches, nil)
        }
        
        task.resume()
    }
}
