//
//  AddMembersTableViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class AddMembersTableViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var team: TeamsMO!
    var availableMembers: [MembersMO] = []
    var selectedMembers: [MembersMO] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    // Private methods
    private func fetchMembers(withNameStartsWith name: String) {
        FirebaseService.shared.fetchMembers(withName: name) { members in
            self.availableMembers = members.filter { memberResult in
                let filteredResult: [Any]? = self.team.members?.filter { member in (member as? MembersMO)?.uid == memberResult.uid}
                return filteredResult == nil || filteredResult?.isEmpty ?? false
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func clearResults() {
        availableMembers = []
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func doCancel(_ sender: Any) {
        selectedMembers = []
        performSegue(withIdentifier: "goBackToTeamTable", sender: self)
    }
    
    @IBAction func doAdd(_ sender: Any) {
        doneButton.isEnabled = false
        
        FirebaseService.shared.addMembers(selectedMembers, toTeam: team) { error in
            if (error != nil) {
                self.present(
                    Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Cannot add members to the team."),
                    animated: true,
                    completion: nil)
                return
            }
            
            self.performSegue(withIdentifier: "goBackToTeamTable", sender: self)
        }
    }
    
}

// MARK: - Table view data source
extension AddMembersTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableMembers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MemberTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: MemberTableViewCell.identifier,
            for: indexPath) as? MemberTableViewCell else {
                fatalError("This cell is not of expected type: MemberTableViewCell")
        }
        let member: MembersMO = availableMembers[indexPath.row]
        
        // Configure the cell...
        cell.displayNameLabel.text = member.name
        cell.member = member

        return cell
    }

}

// MARK: _ Table cell delegates
extension AddMembersTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMembers.append(availableMembers[indexPath.row])
        
        doneButton.isEnabled = !selectedMembers.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedMembers = selectedMembers.filter { member in member.uid != availableMembers[indexPath.row].uid}
        
        doneButton.isEnabled = !selectedMembers.isEmpty
    }
}

// MARK: Search Delegates
extension AddMembersTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text: String = searchBar.text ?? ""
        fetchMembers(withNameStartsWith: text.trim())
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        clearResults()
        searchBar.resignFirstResponder()
    }
}
