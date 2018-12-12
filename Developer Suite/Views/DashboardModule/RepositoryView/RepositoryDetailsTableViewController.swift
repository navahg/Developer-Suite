//
//  RepositoryDetailsTableViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

enum RepositoryDetails: String {
    case branch
    case pullRequest
}

class RepositoryDetailsTableViewController: UITableViewController {
    
    // MARK: Static properties
    internal static let availableDetails: [RepositoryDetails] = [.branch, .pullRequest]
    internal static let branchSegue: String = "showBranches"
    internal static let pullRequestSegue: String = "showPullRequests"
    
    // MARK: Instance Properties
    var repository: RepositoriesMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = repository.name
    }

}

// MARK: Table cell delegates
extension RepositoryDetailsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < RepositoryDetailsTableViewController.availableDetails.count else {
            fatalError("Options added in Storyboard is not updated in the code")
        }
        
        let selectedOption: RepositoryDetails = RepositoryDetailsTableViewController.availableDetails[indexPath.row]
        
        switch selectedOption {
        case .branch:
            self.performSegue(withIdentifier: RepositoryDetailsTableViewController.branchSegue, sender: self)
        case .pullRequest:
            self.performSegue(withIdentifier: RepositoryDetailsTableViewController.pullRequestSegue, sender: self)
        }
    }
}

// MARK: Navigation Delegates
extension RepositoryDetailsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RepositoryDetailsTableViewController.branchSegue,
            let branchesVC: BranchesTableViewController = segue.destination as? BranchesTableViewController {
            branchesVC.repository = repository
        } else if segue.identifier == RepositoryDetailsTableViewController.pullRequestSegue,
            let pullRequestVC: PullRequestTableViewController = segue.destination as? PullRequestTableViewController {
            pullRequestVC.repository = repository
        }
    }
}
