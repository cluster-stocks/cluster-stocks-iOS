//
//  User.swift
//  ClusterStocks
//
//  Created by Sushmitha on 7/4/19.
//  Copyright © 2019 Games. All rights reserved.

import RealmSwift

class User : Object {
    
    @objc dynamic var userName = UUID().uuidString
    @objc dynamic var fullName = ""
    var watchList = List<String>()
    
    override static func primaryKey() -> String {
        return "userName"
    }
}


