//
//  LoginViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 10/7/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions
    @IBAction func doSignIn(_ sender: UIButton) {
        let username: String = usernameTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        
        if (username.isEmpty || password.isEmpty) {
            Utils.showAlert(withTitle: "Fill in all the fields.", andMessage: "Please provide the username and password.", onViewController: self)
            return
        }
        
        // Authenticate the user
        Utils.authenticate(withEmail: username, password: password, onSuccess: onSuccessfulLogin(_:), onError: onAuthenticationFailure(_:))
    }
    
    // MARK: Private methods
    /**
     This handles a successful login event
     - Parameter user: The user model instance representing the current logged in user
     */
    private func onSuccessfulLogin(_ user: UserModel) {
        
    }
    
    /**
     This handles the authentication failure event
     - Parameter error: The error which prevented login
     */
    private func onAuthenticationFailure(_ error: AuthenticationError) {
        switch error {
        case .invalidCredentials:
            Utils.showAlert(withTitle: "Authentication Error", andMessage: "Username/Password is incorrect.", onViewController: self)
        case .authError, .castError:
            Utils.showAlert(withTitle: "Authentication Error", andMessage: "Authentication error. Please try again.", onViewController: self)
        default:
            Utils.showAlert(withTitle: "Authentication Error", andMessage: "Authentication failed. Please contact the administrator.", onViewController: self)
        }
    }
}

