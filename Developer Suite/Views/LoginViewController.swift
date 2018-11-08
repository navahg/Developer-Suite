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
            let alert: UIAlertController = Utils.generateSimpleAlert(withTitle: "Fill in all the fields.", andMessage: "Please provide the username and password.")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        authenticate(withEmail: username, password: password)
    }
    
    // MARK: Private methods
    private func authenticate(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, error) in
            // Handle the error
            if let error: Error = error {
                let alert: UIAlertController = Utils.generateSimpleAlert(withTitle: "Login Failed", andMessage: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // Check if the login is successful
            guard let user = authResult?.user else {
                let alert: UIAlertController = Utils.generateSimpleAlert(withTitle: "Login Failed", andMessage: "Email or password is incorrect.")
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            print(user)
            self.performSegue(withIdentifier: "goToHomeView", sender: self)
        })
    }
}

