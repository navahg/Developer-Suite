//
//  BranchesTableViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class BranchesTableViewController: UITableViewController {

    // MARK: Static props
    internal static let sectionCount: Int = 1
    internal static let cellIdentifier: String = "branch-detail"
    
    // MARK: Properties
    var repository: RepositoriesMO!
    private var loader: UIActivityIndicatorView!
    
    // MARK: lifecycle hooks
    override func loadView() {
        super.loadView()
        
        loader = UIActivityIndicatorView(style: .gray)
        tableView.backgroundView = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        tableView.refreshControl?.tintColor = .primaryColor
        tableView.refreshControl?.attributedTitle = Utils.getPrimaryAttributedText("Fetching Data")
        
        loadData()
    }
    
    // MARK: Private methods
    @objc
    private func loadData() {
        tableView.separatorStyle = .none
        loader.startAnimating()
        GithubService.shared.getBranches(forRepo: repository) { branches, error in
            if error != nil {
                // TODO: Handle error
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                }
                return
            }
            
            self.repository.branches = NSOrderedSet(array: branches!)
            
            DispatchQueue.main.async {
                if (!branches!.isEmpty) {
                    self.tableView.separatorStyle = .singleLine
                }
                self.tableView.refreshControl?.endRefreshing()
                self.loader.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - Table view data source

extension BranchesTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return BranchesTableViewController.sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.branches?.array.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(
            withIdentifier: BranchesTableViewController.cellIdentifier,
            for: indexPath)

        let branch: BranchesMO? = repository.branches?.array[indexPath.row] as? BranchesMO
        
        // Configure the cell
        cell.textLabel?.text = branch?.name

        return cell
    }

}
