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
    
    private var _firebaseAuthListenerHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: Lifecycle hooks
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Register listeners
        registerAuthStateChangeListener()
    }
    
    deinit {
        // Deregister auth state change listener
        if let listener: AuthStateDidChangeListenerHandle = _firebaseAuthListenerHandle {
            Auth.auth().removeStateDidChangeListener(listener)
            try? Auth.auth().signOut()
        }
    }

    // MARK: Actions
    @IBAction func doSignIn(_ sender: UIButton) {
        let username: String = usernameTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        
        // Authenticate the user
        LoginViewController.authenticate(withEmail: username, password: password, onError: onAuthenticationFailure(_:))
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
    private func registerAuthStateChangeListener() {
        let successCallback: (UserMO) -> () = self.onSuccessfulLogin(_:)
        _firebaseAuthListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user: User = user {
                do {
                    let user: UserMO = try DataManager.shared.createUser(user)
                    successCallback(user)
                } catch CoreDataError.insertionFailed {
                    Utils.log("Unable to create UserModel from FirUser")
                } catch CoreDataError.fetchFailed {
                    Utils.log("Unable to fetch UserModel from existing core data")
                } catch {
                    Utils.log("Unknown error happened when creating a user")
                }
            } else {
                Utils.log("Session Ended")
            }
        }
    }
}

