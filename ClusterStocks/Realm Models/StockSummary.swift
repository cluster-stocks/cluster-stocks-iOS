//
//  StockSummary.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/28/19.
//  Copyright © 2019 Games. All rights reserved.

import RealmSwift

class StockSummary : Object {
    
    @objc dynamic var ticker = UUID().uuidString
    @objc dynamic var companyName = ""
    @objc dynamic var currentPrice = ""
    @objc dynamic var previousClosePrice = ""
    @objc dynamic var openPrice = ""
    @objc dynamic var daysRange = ""
    @objc dynamic var yearRange = ""
    @objc dynamic var earningsDate = ""
    @objc dynamic var lastUpdated = ""
    
    override static func primaryKey() -> String {
        return "ticker"
    }
}


