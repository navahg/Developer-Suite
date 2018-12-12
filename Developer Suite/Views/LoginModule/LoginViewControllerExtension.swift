//
//  LoginViewControllerExtension.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/10/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

// Mark: Extending LoginViewController for Navigation

extension LoginViewController {
    
    @IBAction func unwindToLoginView(sender: UIStoryboardSegue) {
        // GitHub Authorization cancelled
        // Do something to handle this case
    }
    
    @IBAction func unwindToLoginViewWithCode(sender: UIStoryboardSegue) {
        // GitHub Authorization succeeded
        if let sourceViewController: OAuthWebViewController = sender.source as? OAuthWebViewController,
            let code: String = sourceViewController.code {
            LoginViewController.getAccessToken(usingCode: code, completion: { (token: String?, error: OAuthError?) -> Void in
                guard let token: String = token, error == nil else {
                    Utils.log("OAuth failed")
                    return
                }
                
                LoginViewController.authenticate(withGitHubToken: token, onError: self.onAuthenticationFailure(_:))
            })
        } else {
            print("Code not found.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PresentOAuthWebView") {
            guard let navController: UINavigationController = segue.destination as? UINavigationController,
                let destinationVC: OAuthWebViewController = navController.topViewController as? OAuthWebViewController
            else {
                Utils.log("The destination Controller is not of extected type for PresentOAuthWebView segue.")
                return
            }
            destinationVC.url = LoginViewController.getGithHubAuthURL()
        } else if (segue.identifier == "NavigateToDashboard") {
            guard let destinationVC: DashboardTabBarController = segue.destination as? DashboardTabBarController,
                let user: UserMO = sender as? UserMO
            else {
                Utils.log("The destination Controller is not of extected type or invalid user model is sent for NavigateToDashboard segue.")
                return
            }
            destinationVC.currentUser = user
        }
    }
}

// Mark: Github OAuth functions
extension LoginViewController {
    /**
     Presents the GitHub authorization page which requests the User to log in and authorize the app
     - Returns: The OAuth URL for GitHub
     */
    static func getGithHubAuthURL() -> URL? {
        let gitHubURL: String = "https://github.com/login/oauth/authorize"
        
        guard let Config: [String: Any] = NSDictionary(contentsOfFile: Utils.ConfigFilePath!) as? [String: Any] else {
            Utils.log("Unable to read the contents of the Config File.")
            return nil
        }
        
        guard let clientID: String = Config["GITHUB_CLIENT_ID"] as? String else {
            Utils.log("GitHub ClienID is not found in the config file.")
            return nil
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "scope", value: "repo notifications user")
        ]
        
        var urlComponents: URLComponents = URLComponents(string: gitHubURL)!
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
    
    /**
     This retrives the Access Token for the GitHub account the user used to login using the code
     sent in the previous OAuth step
     - Parameter usingCode: The Code received by the client when the user signed in
     - Parameter onSuccess: The success callback function called with the UserModel representing the logged in user
     - Parameter onError: The error callback function called with the AuthenticationError caused the authentication to fail
     */
    static func getAccessToken(usingCode code: String, completion: @escaping (_ accessToken: String?, _ error: OAuthError?) -> ()) {
        let githubAuthTokenURL: String = "https://github.com/login/oauth/access_token"
        
        guard let Config: [String: Any] = NSDictionary(contentsOfFile: Utils.ConfigFilePath!) as? [String: Any] else {
            Utils.log("Unable to read the contents of the Config File.")
            completion(nil, OAuthError.keyNotFound)
            return
        }
        
        guard let clientID: String = Config["GITHUB_CLIENT_ID"] as? String,
            let clientSecret: String = Config["GITHUB_CLIENT_SECRET"] as? String
        else {
            Utils.log("GitHub ClienID/ClientSecret is not found in the config file.")
            completion(nil, OAuthError.keyNotFound)
            return
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code", value: code)
        ]
        
        var urlComponents: URLComponents = URLComponents(string: githubAuthTokenURL)!
        urlComponents.queryItems = queryItems
        
        var request: URLRequest = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data: Data = data, error == nil else {
                Utils.log("Github access token fetch failed.")
                completion(nil, OAuthError.authFailed)
                return
            }
            
            guard let responseJSON: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] else {
                Utils.log("Response is not a valid JSON.")
                completion(nil, OAuthError.notValidJSON)
                return
            }
            
            guard let accessToken: String = responseJSON["access_token"] as? String else {
                Utils.log("Access Token not found.")
                completion(nil, OAuthError.tokenNotFound)
                return
            }
            
            completion(accessToken, nil)
        }
        
        task.resume()
    }
}

// Mark: Email Authentication

extension LoginViewController {
    /**
     This logs in the user using Firebase authentication
     - Parameter withEmail: The email provided by the user
     - Parameter password: The password for the account
     - Parameter onError: The error callback function called with the AuthenticationError caused the authentication to fail
     */
    static func authenticate(withEmail email: String, password: String, onError errorCallback: @escaping (_ error: AuthenticationError) -> ()) {
        if (email.isEmpty) {
            // Call error callback if user name is empty
            errorCallback(.noUsername)
            return
        }
        
        if (password.isEmpty) {
            // Call error callback if password is empty
            errorCallback(.noPassword)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, error) in
            // Handle the error
            if let _: Error = error {
                Utils.log("Authentication service error.")
                errorCallback(.authError)
                return
            }
            
            // Check if the login is successful
            if authResult?.user == nil {
                errorCallback(.invalidCredentials)
                return
            }
        })
    }
    
    /**
     This logs in the user using Firebase authentication using GitHub as a provider
     - Parameter withGitHubToken: The access token provided by the github Authentication service
     - Parameter onError: The error callback function called with the AuthenticationError caused the authentication to fail
     */
    static func authenticate(withGitHubToken token: String, onError errorCallback: @escaping (_ error: AuthenticationError) -> ()) {
        let credential: AuthCredential = GitHubAuthProvider.credential(withToken: token)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            // Handle the error
            if let _: Error = error {
                Utils.log("Authentication service error.")
                errorCallback(.authError)
                return
            }
            
            // Check if the login is successful
            if authResult?.user == nil {
                errorCallback(.invalidCredentials)
                return
            }
            
            // If login is successful, store the token in user defaults
            UserDefaults.standard.set(token, forKey: "githubAccessToken")
        }
    }
}
