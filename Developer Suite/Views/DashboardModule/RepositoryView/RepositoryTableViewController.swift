//
//  RepositoryTableViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/9/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

// The types of repositories
enum RepoType: String {
    case owned = "Owned Repositories"
    case collaborating = "Collaborating Repositories"
}

class RepositoryTableViewController: UITableViewController {
    
    // MARK: Class Properties
    private static let sections: [RepoType] = [.owned, .collaborating]
    private static let repositoryDetailsSegue: String = "showRepositoryDetails"
    
    // MARK: Instance Properties
    var repositories: [RepoType: [RepositoriesMO]] = [
        .owned: [],
        .collaborating: []
    ]
    var currentUser: UserMO!
    var selectedRepository: RepositoriesMO? = nil

    // MARK: Lifecycle hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.scrollsToTop = true
        
        currentUser = (self.tabBarController as? DashboardTabBarController)?.currentUser
        
        loadData()
    }
    
    // MARK: Private Methods
    fileprivate func loadData() {
        if let githubUID: String = currentUser.githubId {
            GithubService.shared.getUserRepos(forUID: githubUID) { repositories, error in
                if error != nil || repositories == nil {
                    // TODO: Handle error
                    return
                }
                
                self.currentUser.repositories = NSOrderedSet(array: repositories!)
                
                if !repositories!.isEmpty {
                    self.repositories[.owned] = repositories!.filter { repo in repo.isOwnedBySelf }
                    self.repositories[.collaborating] = repositories!.filter { repo in !repo.isOwnedBySelf }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Table data source
extension RepositoryTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return RepositoryTableViewController.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return RepositoryTableViewController.sections[section].rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let repoType: RepoType = RepositoryTableViewController.sections[section]
        
        return repositories[repoType]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: RepositoryTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: RepositoryTableViewCell.identifier,
            for: indexPath) as? RepositoryTableViewCell else {
                fatalError("This cell is not of expected type: RepositoryTableViewCell")
        }
        let repoType: RepoType = RepositoryTableViewController.sections[indexPath.section]
        
        // Configure the cell
        cell.repositoryNameLabel.text = repositories[repoType]?[indexPath.row].name
        
        if let pullRequestCount: Int = repositories[repoType]?[indexPath.row].pullRequests?.array.count,
            pullRequestCount > 0 {
            cell.activePullRequestCountLabel.text = String(describing: pullRequestCount)
        } else {
            cell.activePullRequestCountLabel.isHidden = true
        }
        
        return cell
    }
}

// MARK: Table Cell Delegates
extension RepositoryTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoType: RepoType = RepositoryTableViewController.sections[indexPath.section]
        selectedRepository = repositories[repoType]![indexPath.row]
        self.performSegue(withIdentifier: RepositoryTableViewController.repositoryDetailsSegue, sender: self)
    }
}

// MARK: Navigation Delegates
extension RepositoryTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RepositoryTableViewController.repositoryDetailsSegue,
            let destinationVC: RepositoryDetailsTableViewController = segue.destination as? RepositoryDetailsTableViewController {
            destinationVC.repository = selectedRepository
        }
    }
}
