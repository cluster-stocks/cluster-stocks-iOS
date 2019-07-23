//
//  RealmUtils.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/28/19.
//  Copyright © 2019 Games. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUtils {
    
    var realm = try! Realm(configuration:  Realm.Configuration.defaultConfiguration)
    
    private static let realmUtils = RealmUtils()

    public static func instance() -> RealmUtils {
        return realmUtils
    }
    
    public func saveStockSummary(stock: StockSummary)
    {
        try! realm.write {
            realm.add(stock, update: true)
        }
    }
    
    public func findAll() -> [StockSummary]
    {
        //StockSummary.self = class's object not instance of class
        let results = realm.objects(StockSummary.self)
        //convert realm Results type to array
        return results.map({$0})
    }
    
    public func deleteStockSummary(stock: StockSummary)
    {
        try! realm.write {
            realm.delete(stock)
        }
    }
    
    func deleteAllStockSummaries() {
        for stock:StockSummary in RealmUtils.instance().findAll() {
            RealmUtils.instance().deleteStockSummary(stock: stock)
        }
    }
    
    public func saveUser(user: User)
    {
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    public func saveUser(email: String, phone:String, fullName:String)
    {
        guard let user = RealmUtils.instance().getCurrentUser() else {
            return
        }
        try! realm.write {
                user.email = email
                user.phoneNumber = phone
                user.fullName = fullName
                realm.add(user, update: true)
        }
    }
    
    public func createUser(userName: String)
    {
        let user = User()
        try! realm.write {
            user.userName = userName
            realm.add(user, update: true)
        }
    }
    
    public func updateUserWatchlist(username: String, watchedStocks:[String]?)
    {
        //Checks if null - safety checks
        guard let user = RealmUtils.instance().getCurrentUser() else {
            return
        }
        //Get the current user object and modify the watchlist of the object. Do not create new user object and new watchlist list object.
        if let currentStocks = watchedStocks, !currentStocks.isEmpty {
            try! realm.write {
                user.watchList.removeAll()
                user.watchList.append(objectsIn: currentStocks)
            }
        } else {
            try! realm.write {
                user.watchList.removeAll()
            }
        }
    }
    
    public func getCurrentUser() -> User? // Optional<User>
    {
        let result = realm.objects(User.self)
        return result.map({$0}).first
    }
    
    public func findAll() -> [User]
    {
        let results = realm.objects(User.self)
        return results.map({$0})
    }
    
    public func deleteUser(user: User)
    {
        try! realm.write {
            realm.delete(user)
        }
    }

    public func deleteAllUsers() {
        for user:User in RealmUtils.instance().findAll() {
            RealmUtils.instance().deleteUser(user: user)
        }
    }
}


