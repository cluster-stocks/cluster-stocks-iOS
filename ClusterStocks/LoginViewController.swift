//
//  LoginViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/27/19.
//  Copyright © 2019 Games. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let client = CSClusterStockAPIClient.default()

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        // Authenticate user
        
        //If sucessfull, Get details of the logged in user
        getUserDetails()
        
    }
    
    
    //After Login in
    func getUserDetails(){
        client.userGet(userName: "sampleUserName").continueWith { (task: AWSTask<CSUserGetResponseMethodModel>?) -> AnyObject? in
            if let result = self.getUserGetResult(task: task) {
                //After doing AWSTask in background dispatch queue, using main dispatch queue for accessing Realm DB.
                DispatchQueue.main.async {
                    self.createUserObject(userDetails: result)
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
        if let interestedStocks = userDetails.watchlist {
            user.watchList.append(objectsIn: interestedStocks)
        }
        RealmUtils.instance().saveUser(user: user)
    }
    
    //On logout
    func deleteUserObject() {
        if let user = RealmUtils.instance().getUser(){
            RealmUtils.instance().deleteUser(user: user)
        }
    }
}

