//
//  SignInViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha Ganesh on 7/14/19.
//  Copyright © 2019 Games. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class SignInViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    var usernameText: String?
    let client = CSClusterStockAPIClient.default()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.password.text = nil
        self.username.text = usernameText
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //After Login in
    func getUserDetails() {
        if let usernametext = self.usernameText {
            client.userGet(userName: usernametext).continueWith { (task: AWSTask<CSUserGetResponseMethodModel>?) -> AnyObject? in
                if let result = self.getUserGetResult(task: task) {
                    //After doing AWSTask in background dispatch queue, using main dispatch queue for accessing Realm DB.
                    DispatchQueue.main.async {
                        self.addUserWatchlist(userDetails: result)
                    }
                    return result
                }
                return nil
            }
        }
    }
    
    
    func getUserGetResult(task: AWSTask<CSUserGetResponseMethodModel>?) -> CSUserGetResponseMethodModel? {
        if let error = task?.error {
            print("Error occurred: \(error)")
            return nil
        } else if let result = task?.result {
            return result
        }
        else {
            return nil
        }
    }
    
    
    func addUserWatchlist(userDetails: CSUserGetResponseMethodModel) {
        if let userName = userDetails.userName {
            if let interestedStocks = userDetails.watchList {
                RealmUtils.instance().updateUserWatchlist(username: userName, watchedStocks: interestedStocks)
            }
        }
        
    }
    
    @IBAction func signInPressed(_ sender: AnyObject) {
        if (self.username.text != nil && self.password.text != nil) {
            let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: self.username.text!, password: self.password.text! )
            self.passwordAuthenticationCompletion?.set(result: authDetails)
        } else {
            let alertController = UIAlertController(title: "Missing information",
                                                    message: "Please enter a valid user name and password",
                                                    preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
            alertController.addAction(retryAction)
        }
    }
}

extension SignInViewController: AWSCognitoIdentityPasswordAuthentication {
    
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        DispatchQueue.main.async {
            if (self.usernameText == nil) {
                self.usernameText = authenticationInput.lastKnownUsername
            }
        }
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as NSError? {
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                if let username = self.username.text {
                    RealmUtils.instance().createUser(userName: username)
                    self.getUserDetails()
                    self.username.text = nil
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

