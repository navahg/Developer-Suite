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
        
        // Check if the user is already signed in using this device
        checkForSignedInUserAndAuthenticate()
    }

    // MARK: Actions
    @IBAction func doSignIn(_ sender: UIButton) {
        let username: String = usernameTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        
        // Authenticate the user
        LoginViewController.authenticate(withEmail: username, password: password, onSuccess: onSuccessfulLogin(_:), onError: onAuthenticationFailure(_:))
    }
    
    // MARK: Private methods
    /**
     This handles a successful login event
     - Parameter user: The user model instance representing the current logged in user
     */
    internal func onSuccessfulLogin(_ user: UserMO) {
        self.performSegue(withIdentifier: "NavigateToDashboard", sender: user)
    }
    
    /**
     This handles the authentication failure event
     - Parameter error: The error which prevented login
     */
    internal func onAuthenticationFailure(_ error: AuthenticationError) {
        switch error {
        case .noUsername:
            Utils.showAlert(withTitle: "Incomplete Form", andMessage: "Please provide a username.", onViewController: self)
        case .noPassword:
            Utils.showAlert(withTitle: "Incomplete Form", andMessage: "Please provide password.", onViewController: self)
        case .invalidCredentials:
            Utils.showAlert(withTitle: "Authentication Error", andMessage: "Username/Password is incorrect.", onViewController: self)
        case .authError, .castError:
            Utils.showAlert(withTitle: "Authentication Error", andMessage: "Authentication error. Please try again.", onViewController: self)
        }
    }
    
    /**
     Checks if the user is already signed in using this device and perform signin for the user
     */
    private func checkForSignedInUserAndAuthenticate() {
        if let firUser: User = Auth.auth().currentUser {
            do {
                let user: UserMO = try DataManager.shared.createUser(firUser)
                onSuccessfulLogin(user)
            } catch CoreDataError.insertionFailed {
                Utils.log("Unable to create UserModel from FirUser")
            } catch {
                Utils.log("Unknown error happened when creating a user")
            }
        }
    }
}

