//
//  UserDefinedErrors.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation

enum AuthenticationError: Error {
    case noUsername
    case noPassword
    case invalidCredentials
    case authError
    case castError
}
