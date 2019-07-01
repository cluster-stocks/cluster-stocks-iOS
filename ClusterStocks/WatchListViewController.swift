//
//  WatchListViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/27/19.
//  Copyright © 2019 Games. All rights reserved.
//

import UIKit
import RealmSwift

class WatchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var watchListTableView: UITableView!
    
    var allStocks: [StockSummary] {
        return StockSummaryUtils.instance().findAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Watch List View controller loads view and supplies table view with data
        self.watchListTableView.dataSource = self
        self.watchListTableView.delegate = self
        populateStockSummaryList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a reusable cell from the cell memory pool. There can 10 stocks in 10 stock cells. If 5 are displayed first, then the pool contains stockCell objects for 5 stocks. If the user scrolls down, the same object created to display the first 5 is reused from the pool.
        //When there is scroll, this method dequeue is called. This saves time by instating only less objects but reuses them
        if let stockCell =  watchListTableView.dequeueReusableCell(withIdentifier: "StockCell") as? StockCell {
            let stock = allStocks[indexPath.row]
            stockCell.ticker.text = stock.ticker
            stockCell.currentPrice.text = String(stock.currentPrice)
            return stockCell
        }
       return UITableViewCell()
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let stock = allStocks[indexPath.row]
         self.performSegue(withIdentifier: "ShowStockSummary", sender: stock)
    }


    public func populateStockSummaryList() {
            let stock1 = StockSummary()
            stock1.ticker="AMZN"
            stock1.companyName="Amzon Company"
            stock1.currentPrice = 1078.987
            stock1.previousClosePrice = 1079.87
            StockSummaryUtils.instance().saveStockSummary(stock: stock1)
        
            let stock2 = StockSummary()
            stock2.ticker="MSFT"
            stock2.companyName="Microsoft  Corporation"
            stock2.currentPrice = 578.987
            stock2.previousClosePrice = 479.87
            StockSummaryUtils.instance().saveStockSummary(stock: stock2)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stock = sender as? StockSummary {
            if let stockVC = segue.destination as? StockSummaryViewController {
                stockVC.stock = stock
            }
        }
    }
    
}

