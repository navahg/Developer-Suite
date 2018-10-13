//
//  LoginViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 10/7/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: Actions
    @IBAction func doSignIn(_ sender: UIButton) {
        let username: String = usernameTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        
        
    }
}

