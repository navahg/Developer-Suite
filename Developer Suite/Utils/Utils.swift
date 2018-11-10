//
//  Utils.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/8/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import os.log

class Utils {
    static func generateSimpleAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return alert
    }
    
    static func showAlert(withTitle title: String, andMessage message: String, onViewController vc: UIViewController) -> Void {
        let alert: UIAlertController = generateSimpleAlert(withTitle: "Fill in all the fields.", andMessage: "Please provide the username and password.")
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func authenticate(withEmail email: String, password: String, onSuccess successCallback: @escaping (_ user: UserModel) -> (), onError errorCallback: @escaping (_ error: AuthenticationError) -> ()) -> Void {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, error) in
            // Handle the error
            if let _: Error = error {
                os_log("Authentication service error.", log: .default, type: .debug)
                errorCallback(.authError)
                return
            }
            
            // Check if the login is successful
            guard let user: User = authResult?.user else {
                errorCallback(.invalidCredentials)
                return
            }
            
            guard let userModel: UserModel = UserModel(fromFIRUser: user) else {
                errorCallback(.castError)
                return
            }
            
            successCallback(userModel)
        })
    }
}
