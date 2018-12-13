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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repositories: [RepoType: [RepositoriesMO]] = [
        .owned: [],
        .collaborating: []
    ]
    var unfilteredRepositories: [RepositoriesMO] = []
    var currentUser: UserMO!
    var selectedRepository: RepositoriesMO? = nil
    
    private var loader: UIActivityIndicatorView!

    // MARK: Lifecycle hooks
    override func loadView() {
        super.loadView()
        
        loader = UIActivityIndicatorView(style: .gray)
        searchBar.delegate = self
        tableView.backgroundView = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.scrollsToTop = true
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        tableView.refreshControl?.tintColor = .primaryColor
        tableView.refreshControl?.attributedTitle = Utils.getPrimaryAttributedText("Fetching Data")
        
        currentUser = (self.tabBarController as? DashboardTabBarController)?.currentUser
        
        loadData()
    }
    
    // MARK: Private Methods
    @objc
    private func loadData() {
        tableView.separatorStyle = .none
        loader.startAnimating()
        if let githubUID: String = currentUser.githubId {
            GithubService.shared.getUserRepos(forUID: githubUID) { repositories, error in
                if error != nil || repositories == nil {
                    // TODO: Handle error
                    DispatchQueue.main.async {
                        self.loader.stopAnimating()
                    }
                    return
                }
                
                self.currentUser.repositories = NSOrderedSet(array: repositories!)
                self.unfilteredRepositories = repositories!
                
                if !repositories!.isEmpty {
                    self.repositories[.owned] = repositories!.filter { repo in repo.isOwnedBySelf }
                    self.repositories[.collaborating] = repositories!.filter { repo in !repo.isOwnedBySelf }
                }
                
                DispatchQueue.main.async {
                    if (!repositories!.isEmpty) {
                        self.tableView.separatorStyle = .singleLine
                    }
                    self.tableView.refreshControl?.endRefreshing()
                    self.loader.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func applyFilter(_ predicate: String?) {
        self.repositories[.owned] = unfilteredRepositories.filter { repo in
            return repo.isOwnedBySelf && (
                predicate == nil
                || repo.name?.lowercased().range(of: predicate!) != nil
            )
        }
        self.repositories[.collaborating] = unfilteredRepositories.filter { repo in
            return !repo.isOwnedBySelf && (
                predicate == nil
                    || repo.name?.lowercased().range(of: predicate!) != nil
            )
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
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

// MARK: Search Delegates
extension RepositoryTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate: String? = nil
        
        if searchText != "" {
            predicate = searchText.lowercased()
        }
        
        applyFilter(predicate)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        applyFilter(nil)
        searchBar.text = nil
        searchBar.resignFirstResponder()
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
