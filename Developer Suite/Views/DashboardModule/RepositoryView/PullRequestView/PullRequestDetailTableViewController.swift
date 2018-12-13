//
//  PullRequestDetailTableViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/11/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class PullRequestDetailTableViewController: UITableViewController {
    
    // MARK: Static Properties
    internal static var dateFormatter: DateFormatter {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "HH:mm:ss MMM d, yyyy"
        return df
    }
    
    internal static let detailCellHeight: CGFloat = 150
    internal static let commentCellHeight: CGFloat = 104
    
    internal static let hasConflictText: String = "Has conflicts"
    internal static let hasNoConflictText: String = "Has no conflicts"
    internal static let hasConflictImageName: String = "HasConflict"
    internal static let hasNoConflictImageName: String = "NoConflict"
    
    private static let exitSegue: String = "unwindToPullRequestsFromPRDetail"
    
    // MARK: Properties
    var pullRequest: PullRequestsMO!
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var closePullRequestButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var conflictIndicatorImage: UIImageView!
    @IBOutlet weak var conflictIndicatorText: UILabel!
    @IBOutlet weak var mergeButton: UIButton!
    
    private var loader: UIActivityIndicatorView!
    
    // MARK: - Lifecycle Hooks
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
        
        // Setting border color
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.borderBlueColor.cgColor
        
        loadData()
    }
    
    // MARK: Private Methods
    @objc
    private func loadData() {
        if pullRequest != nil {
            loader.startAnimating()
            let group: DispatchGroup = DispatchGroup()
            
            group.enter()
            GithubService.shared.getPullRequestDetails(forPullRequest: pullRequest) { details, error in
                if error != nil || details == nil {
                    // TODO: Handle error
                    group.leave()
                    return
                }
                
                self.pullRequest.head = (details!["head"] as? [String: Any] ?? [:])["ref"] as? String
                self.pullRequest.base = (details!["base"] as? [String: Any] ?? [:])["ref"] as? String
                self.pullRequest.commitsCount = details!["commits"] as? Int32 ?? 0
                self.pullRequest.isMergable = details!["mergeable"] as? Bool ?? false
                group.leave()
            }
            
            group.enter()
            GithubService.shared.getPRComments(forPullRequest: pullRequest) { comments, error in
                if error != nil || comments == nil {
                    // TODO: Handle error
                    group.leave()
                    return
                }
                
                self.pullRequest.comments = NSSet(array: comments!)
                group.leave()
            }
            
            group.notify(queue: .main) {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.loader.stopAnimating()
                    self.upadteView()
                }
            }
        }
    }
    
    private func upadteView() {
        mergeButton.isEnabled = pullRequest.isMergable
        mergeButton.alpha = pullRequest.isMergable ? 1 : 0.3
        mergeButton.backgroundColor = pullRequest.isMergable ? .success : .failure

        if pullRequest.isMergable {
            conflictIndicatorText.text = PullRequestDetailTableViewController.hasNoConflictText
            conflictIndicatorImage.image = UIImage(named: PullRequestDetailTableViewController.hasNoConflictImageName)
        } else {
            conflictIndicatorText.text = PullRequestDetailTableViewController.hasConflictText
            conflictIndicatorImage.image = UIImage(named: PullRequestDetailTableViewController.hasConflictImageName)
        }
        tableView.reloadData()
    }
    
    private func disableInteractions() {
        // Disable the button the while making the request
        commentButton.isEnabled = false
        commentButton.alpha = 0.3
        closePullRequestButton.isEnabled = false
        closePullRequestButton.alpha = 0.3
        mergeButton.isEnabled = false
        mergeButton.alpha = 0.3
    }
    
    private func enableInteractions() {
        // Enable the buttons
        commentButton.isEnabled = true
        commentButton.alpha = 1
        closePullRequestButton.isEnabled = true
        closePullRequestButton.alpha = 1
        mergeButton.isEnabled = pullRequest.isMergable
        mergeButton.alpha = pullRequest.isMergable ? 1 : 0.3
    }
    
    // MARK: Actions
    @IBAction func doMerge(_ sender: Any) {
        disableInteractions()
        
        GithubService.shared.mergePullRequest(pullRequest) { message, error in
            if error != nil {
                // TODO: Handle error
                DispatchQueue.main.async {
                    self.enableInteractions()
                    self.present(
                        Utils.generateSimpleAlert(withTitle: "Error", andMessage: message ?? "Cannot merge the pull request"),
                        animated: true,
                        completion: nil)
                }
                return
            }
            
            self.present(
                Utils.generateSimpleAlert(withTitle: "Success", andMessage: message ?? "Pull request has been merged successfully!"),
                animated: true,
                completion: {
                    DispatchQueue.main.async {
                        self.enableInteractions()
                        self.performSegue(withIdentifier: PullRequestDetailTableViewController.exitSegue, sender: self)
                    }
            })
        }
    }
    
    @IBAction func doClosePullRequest(_ sender: Any) {
        disableInteractions()
        
        GithubService.shared.closePullRequest(pullRequest) { message, error in
            if error != nil {
                // TODO: Handle error
                DispatchQueue.main.async {
                    self.enableInteractions()
                    self.present(
                        Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Cannot close the pull request"),
                        animated: true,
                        completion: nil)
                }
                return
            }
            
            self.present(
                Utils.generateSimpleAlert(withTitle: "Success", andMessage: message!),
                animated: true,
                completion: {
                    DispatchQueue.main.async {
                        self.enableInteractions()
                        self.performSegue(withIdentifier: PullRequestDetailTableViewController.exitSegue, sender: self)
                    }
            })
        }
    }
    
    @IBAction func doComment(_ sender: Any) {
        guard let comment: String = commentTextView.text, !comment.isEmpty else {
            self.enableInteractions()
            self.present(
                Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Give a description to insert a comment"),
                animated: true,
                completion: nil)
            return
        }
        
        disableInteractions()
        
        GithubService.shared.postComment(comment, forPullRequest: pullRequest) { comment, error in
            if error != nil || comment == nil {
                // TODO: Handle error
                DispatchQueue.main.async {
                    self.enableInteractions()
                    self.present(
                        Utils.generateSimpleAlert(withTitle: "Error", andMessage: "Cannot post the comment"),
                        animated: true,
                        completion: nil)
                }
                return
            }
            
            self.pullRequest.addToComments(comment!)
            DispatchQueue.main.async {
                self.enableInteractions()
                self.commentTextView.text = ""
                self.tableView.reloadData()
            }
        }
    }

}

// MARK: - Table view data source
extension PullRequestDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return "Comments"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return pullRequest.comments?.allObjects.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell: PullRequestDetailTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: PullRequestDetailTableViewCell.identifier,
                for: indexPath) as? PullRequestDetailTableViewCell else {
                    fatalError("Unexpected Table cell type found when expecting PullRequestDetailTableViewCell")
            }

            cell.titleLabel.text = pullRequest.title
            cell.prNumberLabel.text = String(format: PullRequestDetailTableViewCell.prNumberStringFormat, pullRequest.number)
            cell.userLabel.text = pullRequest.creator
            cell.headLabel.text = pullRequest.head
            cell.baseLabel.text = pullRequest.base
            cell.timeStampLabel.text = PullRequestDetailTableViewController.dateFormatter.string(from: (pullRequest.createdAt! as Date))
            cell.commitDescriptionLabel.text = String(
                format: PullRequestDetailTableViewCell.commitDescriptionStringFormat,
                pullRequest.commitsCount
            )
            
            
            return cell
        } else {
            guard let cell: PullRequestCommentTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: PullRequestCommentTableViewCell.identifier,
                for: indexPath) as? PullRequestCommentTableViewCell else {
                    fatalError("Unexpected Table cell type found when expecting PullRequestCommentTableViewCell")
            }
            let comment: PRCommentsMO? = pullRequest.comments?.allObjects[indexPath.row] as? PRCommentsMO
            
            // Configure cell
            cell.userLabel.text = comment?.creator
            cell.timestampLabel.text = PullRequestDetailTableViewController.dateFormatter.string(from: (comment!.updatedAt! as Date))
            cell.bodyTextView.text = comment?.body ?? ""
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        if indexPath.section == 0 {
            return PullRequestDetailTableViewController.detailCellHeight
        }
        
        return PullRequestDetailTableViewController.commentCellHeight
    }

}
