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

//SImulator Realm File 
//Users⁩/sushmitha⁩/Library⁩/Developer⁩/CoreSimulator⁩/Devices⁩/1DEE3B5E-19F6-41ED-AEA5-88A10FAC0E77⁩/data⁩/Containers⁩/Data⁩/Application⁩/A79AC64D-9286-4CC9-B04B-05836A3878CF⁩/Documents
//C2B06722-6FBC-401D-A9DA-6BCBEAA0350E⁩ ▸
//D5DE5355-AE5E-4BDE-AEAA-C94626BB7FF0⁩
