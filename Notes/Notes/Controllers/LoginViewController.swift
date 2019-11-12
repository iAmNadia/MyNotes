//
//  LoginViewController.swift
//  Notes
//
//  Created by Надежда Морозова on 10/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import WebKit

protocol AuthViewControllerDelegate: class {
    func handleTokenChanged(token: String)
}

class LoginViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?


    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let link = "\(Github.AuthUrl)?client_id=\(Github.ClientId)&redirect_uri=\(Github.RedirectUrl)&scope=\(Github.Scope)"
        
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            view.activityIndicator(true)
            webView.load(request)
        }
    }
    
    func handleGithubCode(code: String) {
        
        let urlString = "https://github.com/login/oauth/access_token"
        if let tokenUrl = URL(string: urlString) {
            
            let req = NSMutableURLRequest(url: tokenUrl)
            req.httpMethod = "POST"
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            req.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let params = [
                "client_id" : Github.ClientId,
                "client_secret" : Github.ClientSecret,
                "code" : code
            ]
            
            req.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
                DispatchQueue.main.async {
                    self.view.activityIndicator(false)
                }
                if let error = error {
                    self.showAlert(error.localizedDescription)
                }
                if let data = data {
                    do {
                        if let content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                            if let accessToken = content["access_token"] as? String {
                                print(accessToken)
                                Github.Token = accessToken
                                DispatchQueue.main.async {
                                    let window = (UIApplication.shared.delegate as? AppDelegate)?.window
                                    window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainContainer")
                                    window?.makeKeyAndVisible()
                                }
                            }
                        }
                    } catch {
                        self.showAlert("Unexpected Error")
                    }
                } else {
                    self.showAlert("Something wrong has happened!")
                }
            }
            task.resume()
        }
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if let url = webView.url?.absoluteString,
            let queryItems = URLComponents(string: url)?.queryItems,
            let code = queryItems.filter({$0.name == "code"}).first?.value {
            view.activityIndicator(true)
            webView.isHidden = true
            handleGithubCode(code: code)
            print("CODE VALUE IS", code)
        } else {
            view.activityIndicator(false)
        }
    }
}
