//
//  MessageDelegate.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 12/13/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation

// MARK: - Delegate for loading messages
protocol MessageDelegate: class {
    func didReceiveNewMessage(_ message: MessageMO)
}
