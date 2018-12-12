//
//  AccountTableViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/4/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountTableViewController: UITableViewController {
    
    // MARK: Static Constants
    static let profileSettings: String = "profile"
    static let notificationSettings: String = "notification"
    static let signOut: String = "signOut"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table View User Interactions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == AccountTableViewController.signOut {
            guard
                let dashboardController: DashboardTabBarController = self.tabBarController as? DashboardTabBarController else {
                    Utils.log("The Tab Bar Controller is not of extected type.")
                    return
            }
            
            dashboardController.doSignOut()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
