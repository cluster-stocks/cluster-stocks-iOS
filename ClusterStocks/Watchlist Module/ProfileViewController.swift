//
//  ProfileViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/27/19.
//  Copyright © 2019 Games. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class ProfileViewController: UIViewController {

    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if (self.user == nil) {
            //Sets user as previously signed in user
            self.user = self.pool?.currentUser()
        }
        self.updateUserProfile()
    }
    

    func updateUserProfile() {
        self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
                self.title = self.user?.username
                self.storeUserDetails()
                self.displayUserProfile()
            })
            return nil
        }
    }
    
    func storeUserDetails() {
        if let response = self.response  {
            if let userAttributes = response.userAttributes {
                
                var fullName = ""
                var emailAddress = ""
                var phoneNumber = ""
                for userAttribute in userAttributes {
                    switch userAttribute.name {
                        case "name":
                            if let name = userAttribute.value {
                                fullName = name
                            }
                        case "email":
                            if let email = userAttribute.value {
                                emailAddress = email
                            }
                        case "phone_number":
                            if let phone = userAttribute.value {
                                phoneNumber = phone
                            }
                        default:
                            break
                    }
                }
                RealmUtils.instance().saveUser(email: emailAddress, phone: phoneNumber, fullName: fullName)
            }
        }
    }
    
    func displayUserProfile() {
        if let user = RealmUtils.instance().getCurrentUser() {
          userName.text = user.userName
          fullName.text = user.fullName
          email.text = user.email
          phoneNumber.text = user.phoneNumber
        }
    }
    
    @IBAction func SignOutPressed(_ sender: Any) {
        self.user?.signOut()
        self.title = nil
        self.response = nil
        RealmUtils.instance().deleteAllUsers()
        RealmUtils.instance().deleteAllStockSummaries()
        self.updateUserProfile()
    }
}

