//
//  RepositoryDelegate.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation

// MARK: - Delegate for loading repository data
protocol RepositoryDataDeleagte: class {
    func didReceiveData(sender:DashboardTabBarController)
}
