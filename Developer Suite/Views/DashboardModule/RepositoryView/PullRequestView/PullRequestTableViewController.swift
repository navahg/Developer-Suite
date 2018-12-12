//
//  PullRequestTableViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class PullRequestTableViewController: UITableViewController {
    
    // MARK: Static Properties
    internal static let sectionCount: Int = 1
    internal static let detailSegue: String = "showPRDetail"
    internal static let createPRSegue: String = "showCreatePR"
    
    // MARK: Instance Properties
    var repository: RepositoriesMO!
    var selectedPullRequest: PullRequestsMO?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: Private Methods
    private func loadData() {
        GithubService.shared.getPullRequests(forRepo: repository) { pullRequests, error in
            if error != nil || pullRequests == nil {
                // TODO: Handle error
                return
            }
            
            self.repository.pullRequests = NSOrderedSet(array: pullRequests!)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Actions
    @IBAction func unwindForPullRequests(segue: UIStoryboardSegue) {
        if let source: CreatePullRequestViewController = segue.source as? CreatePullRequestViewController,
            let pullRequest: PullRequestsMO = source.pullRequest {
            repository.addToPullRequests(pullRequest)
            tableView.reloadData()
        }
    }
    
}

// MARK: - Table view data source
extension PullRequestTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return PullRequestTableViewController.sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.pullRequests?.array.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PullRequestTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: PullRequestTableViewCell.identifier,
            for: indexPath) as? PullRequestTableViewCell else {
              fatalError("Unexpected cell type is received for PullRequestTableViewCell")
        }
        
        let pullRequest: PullRequestsMO? = repository.pullRequests?.array[indexPath.row] as? PullRequestsMO
        
        // Configure cell
        cell.nameLabel.text = pullRequest?.title
        cell.subtitleLabel.text = String(
            format: PullRequestTableViewCell.subtitleStringFormat,
            pullRequest?.number ?? 0,
            pullRequest?.creator ?? ""
        )
        
        return cell
    }
}

// MARK: - Table cell delegates
extension PullRequestTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPullRequest = repository.pullRequests?.array[indexPath.row] as? PullRequestsMO
        
        performSegue(withIdentifier: PullRequestTableViewController.detailSegue, sender: self)
    }
}

// MARK: - Navigation Delegates
extension PullRequestTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PullRequestTableViewController.detailSegue,
            let pullRequest: PullRequestsMO = selectedPullRequest,
            let destinationVC: PullRequestDetailTableViewController = segue.destination as? PullRequestDetailTableViewController {
            destinationVC.pullRequest = pullRequest
        } else if segue.identifier == PullRequestTableViewController.createPRSegue,
            let destinationVC: CreatePullRequestViewController = segue.destination as? CreatePullRequestViewController {
            destinationVC.repository = repository
        }
    }
}
