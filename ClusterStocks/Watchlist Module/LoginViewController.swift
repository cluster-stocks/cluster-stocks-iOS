//
//  LoginViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/27/19.
//  Copyright © 2019 Games. All rights reserved.
// Not in use

import UIKit

class LoginViewController: UIViewController {

    let client = CSClusterStockAPIClient.default()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Use when logging out
        RealmUtils.instance().deleteAllUsers()
        RealmUtils.instance().deleteAllStockSummaries()
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        // Authenticate user
        
        //If sucessfull, Get details of the logged in user
        getUserDetails()
        
    }
    
        func createUserPoolObject() {
            //setup service config
           
            
        }
    
    //After Login in
    func getUserDetails(){
        client.userGet(userName: "nadya").continueWith { (task: AWSTask<CSUserGetResponseMethodModel>?) -> AnyObject? in
            if let result = self.getUserGetResult(task: task) {
                //After doing AWSTask in background dispatch queue, using main dispatch queue for accessing Realm DB.
                DispatchQueue.main.async {
                    self.createUserObject(userDetails: result)
                    self.performSegue(withIdentifier: "showAppTab", sender: self)
                }
                return result
            }
            return nil
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
        
    
    func createUserObject(userDetails: CSUserGetResponseMethodModel) {
        let user = User()
        if let userName = userDetails.userName {
                user.userName = userName
        }
        if let fullName = userDetails.fullName {
            user.fullName = fullName
        }
        if let interestedStocks = userDetails.watchList {
            user.watchList.append(objectsIn: interestedStocks)
        }
        RealmUtils.instance().saveUser(user: user)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return RealmUtils.instance().getCurrentUser() != nil
    }
}

