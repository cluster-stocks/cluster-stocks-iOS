//
//  StockSummaryUtils.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/28/19.
//  Copyright © 2019 Games. All rights reserved.
//

import Foundation
import RealmSwift

class StockSummaryUtils {
    
    var realm = try! Realm(configuration:  Realm.Configuration.defaultConfiguration)
    
    private static let stockSummaryUtils = StockSummaryUtils()

    public static func instance() -> StockSummaryUtils {
        return stockSummaryUtils
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
    
}
