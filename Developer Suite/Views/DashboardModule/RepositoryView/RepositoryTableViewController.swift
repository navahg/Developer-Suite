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
    private static let cellIdentifier: String = "repository-cell"
    
    // MARL: Instance Properties
    var repositories: [RepoType: [RepositoriesMO]] = [
        .owned: [],
        .collaborating: []
    ]
    var dashboardController: DashboardTabBarController!

    // MARK: Lifecycle hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.scrollsToTop = true
        
        dashboardController = self.tabBarController as? DashboardTabBarController
        dashboardController.repositoryDelegate = self
        
        loadData()
    }
    
    // MARK: Private Methods
    fileprivate func loadData() {
        let repositoriesData: [RepositoriesMO] = dashboardController.currentUser.repositories?.array as? [RepositoriesMO] ?? []
        
        if !repositoriesData.isEmpty {
            repositories[.owned] = repositoriesData.filter { repo in repo.isOwnedBySelf }
            repositories[.collaborating] = repositoriesData.filter { repo in !repo.isOwnedBySelf }
        }
    }
}

// MARK: - Repository Data Delegate
extension RepositoryTableViewController: RepositoryDataDeleagte {
    func didReceiveData(sender: DashboardTabBarController) {
        loadData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table view delegates
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
            withIdentifier: RepositoryTableViewController.cellIdentifier,
            for: indexPath) as? RepositoryTableViewCell else {
                fatalError("This cell is not of expected type: RepositoryTableViewCell")
        }
        let repoType: RepoType = RepositoryTableViewController.sections[indexPath.section]
        
        // Configure the cell
        cell.repositoryNameLabel.text = repositories[repoType]?[indexPath.row].name
        
        return cell
    }
}
