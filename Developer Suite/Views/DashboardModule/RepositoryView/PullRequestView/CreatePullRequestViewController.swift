//
//  CreatePullRequestViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/11/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class CreatePullRequestViewController: UIViewController {
    
    // MARK: Static Properties
    private static let exitSegue: String = "unwindForPullRequests"

    // MARK: Properties
    var repository: RepositoriesMO!
    var pullRequest: PullRequestsMO?
    var headBranch: BranchesMO?
    var baseBranch: BranchesMO?
    
    var branchTypes: [String] = ["Head", "Base"]
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var branchPickerView: UIPickerView!
    @IBOutlet weak var createButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        branchPickerView.dataSource = self
        branchPickerView.delegate = self
        
        // Setting up view
        titleTextField.layer.borderColor = UIColor.borderBlueColor.cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.borderBlueColor.cgColor
        commentTextView.layer.cornerRadius = 4
        
        loadData()
    }
    
    // MARK: Private methods
    private func loadData() {
        GithubService.shared.getBranches(forRepo: repository) { branches, error in
            if error != nil || branches == nil {
                // TODO: Handle error
                return
            }
            self.repository.branches = NSSet(array: branches!)
            
            // Setting default values
            self.headBranch = branches!.first
            self.baseBranch = branches!.first
            
            DispatchQueue.main.async {
                self.branchPickerView.reloadAllComponents()
            }
        }
    }
    
    // MARK: Actions
    @IBAction func doCreatePullRequest(_ sender: Any) {
        
        guard let title: String = titleTextField.text, !title.isEmpty else {
            self.present(
                Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Provide a title."),
                animated: true,
                completion: nil)
            return
        }
        guard let head: BranchesMO = headBranch else {
            self.present(
                Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Select a head branch"),
                animated: true,
                completion: nil)
            return
        }
        guard let base: BranchesMO = baseBranch, base != head else {
            self.present(
                Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Select a base branch different from head"),
                animated: true,
                completion: nil)
            return
        }
        let comment: String = commentTextView.text
        
        // Disable the button
        createButton.isEnabled = false
        createButton.alpha = 0.3
        
        GithubService.shared.createPullRequest(
            title,
            withComment: comment,
            fromBranch: head,
            toBranch: base,
            inRepository: repository) { pullRequest, error in
                if error != nil || pullRequest == nil {
                    // TODO: Handle error
                    DispatchQueue.main.async {
                        self.createButton.isEnabled = true
                        self.createButton.alpha = 1
                        self.present(
                            Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Cannot create a PR"),
                            animated: true,
                            completion: nil)
                    }
                    return
                }
                
                self.pullRequest = pullRequest
                
                DispatchQueue.main.async {
                    // Enable the button
                    self.createButton.isEnabled = true
                    self.createButton.alpha = 1
                    self.performSegue(withIdentifier: CreatePullRequestViewController.exitSegue, sender: self)
                }
        }
    }
    
}

// MARK: - PickerView Data source
extension CreatePullRequestViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return branchTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return repository.branches?.allObjects.count ?? 0
    }

}

// MARK: - Picker View delegate
extension CreatePullRequestViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (repository.branches?.allObjects[row] as? BranchesMO)?.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if (row < 0) {
                headBranch = nil
                return
            }
            headBranch = repository.branches?.allObjects[row] as? BranchesMO
        } else {
            if (row < 0) {
                baseBranch = nil
                return
            }
            baseBranch = repository.branches?.allObjects[row] as? BranchesMO
        }
    }
    
}
