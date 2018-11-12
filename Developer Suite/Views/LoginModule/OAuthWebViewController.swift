//
//  OAuthWebViewController.swift
//  Developer Suite
//
//  Created by RAGHAVAN RENGANATHAN on 11/11/18.
//  Copyright © 2018 RAGHAVAN RENGANATHAN. All rights reserved.
//

import UIKit
import WebKit

class OAuthWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    // Mark: Properties
    @IBOutlet weak var webView: WKWebView!
    var url: URL?
    var code: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        let url: URL? = self.url ?? URL(string: "")
        let urlRequest: URLRequest = URLRequest(url: url!)
        
        webView.load(urlRequest)
    }
    
    // MARK: Private methods
    /**
     Unwinds to the LoginViewController with the code set to the one received from github
     */
    func performSuccessSegue() {
        self.performSegue(withIdentifier: "GitHubAuthorizationSuccess", sender: self)
    }
    
    // MARK: WKNavigation delegates
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let callbackURL: URL = webView.url, callbackURL.absoluteString.contains("/auth/handler?code") {
            let urlComponents: URLComponents = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true)!
            
            if let code: URLQueryItem = urlComponents.queryItems?.first(where: { $0.name == "code" }) {
                self.code = code.value ?? ""
                performSuccessSegue()
            }
        }
    }
    
    // MARK: Navigation delegates
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueID: String = segue.identifier, segueID == "GitHubAuthorizationFailure" {
            // github authorization is cancelled, reset the code
            code = nil
            return
        }
    }
}
