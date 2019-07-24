//
//  ChangePasswordViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha Ganesh on 7/4/19.
//  Copyright © 2019 Games. All rights reserved.
//

import Foundation
import UIKit
import AWSCognitoIdentityProvider

class ChangePasswordViewController: UIViewController {
    
    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var retypedNewPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
    }
    
    func verifyPasswordFieldEntries() {
        if (self.oldPassword.text != nil && !self.oldPassword.text!.isEmpty && self.newPassword.text != nil  && !self.newPassword.text!.isEmpty && self.retypedNewPassword.text != nil && !self.retypedNewPassword.text!.isEmpty) {
            if(self.newPassword.text != self.retypedNewPassword.text) {
                let alertController = UIAlertController(title: "Incorrect information",
                                                        message: "New and retyped password should match",
                                                        preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                self.present(alertController, animated: true, completion:  nil)
            }
        }
        else {
            let alertController = UIAlertController(title: "Missing information",
                                                    message: "Please enter all the password fields",
                                                    preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
            alertController.addAction(retryAction)
            self.present(alertController, animated: true, completion:  nil)
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        verifyPasswordFieldEntries()
        if let userName = RealmUtils.instance().getCurrentUser()?.userName {
            if let poolUser = self.pool?.getUser(userName) {
                self.user = poolUser
                self.user?.changePassword((self.oldPassword.text)!, proposedPassword: (self.newPassword.text)!).continueWith{(task: AWSTask<AWSCognitoIdentityUserChangePasswordResponse>) -> AnyObject? in
                    DispatchQueue.main.async(execute: {
                        if let error = task.error as NSError? {
                            let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                                    message: error.userInfo["message"] as? String,
                                                                    preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            
                            self.present(alertController, animated: true, completion:  nil)
                        } else {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                    return nil
                }
            }
        }
    }
    
}
