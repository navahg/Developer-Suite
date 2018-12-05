//
//  DashboardCustomDelegates.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/4/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation

// MARK: - Delegate for loading chat
protocol ChatDataDelegate {
    func didReceiveData(sender:DashboardTabBarController)
}

// MARK: - Delegate for loading team data
protocol TeamDataDeleagte {
    func didReceiveData(sender:DashboardTabBarController)
}
