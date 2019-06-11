//
//  StockViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/27/19.
//  Copyright © 2019 Games. All rights reserved.
//

import UIKit
import RealmSwift

class StockViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display()
    }

    public func populateStockSummaryList()
    {
            let stock1 = StockSummary()
            stock1.ticker="AMZN"
            stock1.name="Amzon Company"
            stock1.currentPrice = 1078.987
            stock1.previousPrice = 1079.87
            StockSummaryUtils.instance().saveStockSummary(stock: stock1)
        
            let stock2 = StockSummary()
            stock2.ticker="MSFT"
            stock2.name="Microsoft  Corporation"
            stock2.currentPrice = 578.987
            stock2.previousPrice = 479.87
            StockSummaryUtils.instance().saveStockSummary(stock: stock2)
    }
    
    public func display()
    {
        populateStockSummaryList()
        let allStocks = StockSummaryUtils.instance().findAll()
        print(allStocks)
    }
    
}

