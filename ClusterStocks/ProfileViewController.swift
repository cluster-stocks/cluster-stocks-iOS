//
//  ProfileViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/27/19.
//  Copyright © 2019 Games. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var fullName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display()
    }
    
    func display() {
        if let user = RealmUtils.instance().getUser() {
          userName.text = user.userName
          fullName.text = user.fullName
        }
    }
    
   // https://stackoverflow.com/questions/34102465/make-images-with-name-initials-like-gmail-in-swift-programmatically-for-ios
}

