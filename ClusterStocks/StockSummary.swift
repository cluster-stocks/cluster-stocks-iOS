//
//  StockSummary.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/28/19.
//  Copyright © 2019 Games. All rights reserved.

import RealmSwift

class StockSummary : Object {
    @objc dynamic var ticker = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var currentPrice = 0.0
    @objc dynamic var previousPrice = 0.0
    
    override static func primaryKey() -> String {
        return "ticker"
    }
}


