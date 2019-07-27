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
    let client = CSClusterStockAPIClient.default()
    
    var allStocks: [StockSummary] {
        return RealmUtils.instance().findAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Watch List View controller loads view and supplies table view with data
        self.watchListTableView.reloadData()
        self.watchListTableView.dataSource = self
        self.watchListTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.watchListTableView.reloadData()
        populateStockSummaryList()
    }
    
    // Get all the stock summaries, store in realm and populate the watchlist UI
    func populateStockSummaryList() {
        if let user = RealmUtils.instance().getCurrentUser() {
            for ticker in user.watchList {
                getStock(ticker: ticker)
            }
        }
        
    }
    func getStock(ticker: String){
        client.stockGet(ticker: ticker).continueWith {(task: AWSTask<CSStockGetResponseMethodModel>?) -> AnyObject? in
            if let result = self.getStockGetResult(task: task) {
                //After doing AWSTask in background dispatch queue, using main dispatch queue for accessing Realm DB.
                DispatchQueue.main.async {
                    self.createStockSummaryObject(stockDetails: result)
                    self.watchListTableView.reloadData()
                }
                return result
            }
            return nil
        }
    }
    
    func getStockGetResult(task: AWSTask<CSStockGetResponseMethodModel>?) -> CSStockGetResponseMethodModel? {
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
    func createStockSummaryObject(stockDetails: CSStockGetResponseMethodModel) {
        let stock = StockSummary()
        if let stockTicker = stockDetails.ticker {
            stock.ticker = stockTicker
        }
        if let stockCP = stockDetails.currentPrice {
            stock.currentPrice = stockCP
        }
        if let stockPCP = stockDetails.previousClose {
            stock.previousClosePrice = stockPCP
        }
        if let name = stockDetails.nameOfTheListing {
            stock.companyName = name
        }
        if let week52Range = stockDetails.week52Range {
            stock.yearRange = week52Range
        }
        if let dayRange = stockDetails.daysRange {
            stock.daysRange = dayRange
        }
        if let open = stockDetails.open {
            stock.openPrice = open
        }
        if let updateTime = stockDetails.updatedDateTime {
            stock.lastUpdated = updateTime
        }
        if let earningsDate = stockDetails.earningsDate {
            if (earningsDate.count == 1) {
                stock.earningsDate = earningsDate[0]
            }
            else if (earningsDate.count == 2) {
                stock.earningsDate = earningsDate[0] + "-" + earningsDate[1]
            }
        }
        RealmUtils.instance().saveStockSummary(stock: stock)
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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //internal parameter - forRowAt and indexpath are alias
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let stock = self.allStocks[indexPath.row]
            if let userPutRequestInput = CSUserPutRequestMethodModel() {
                userPutRequestInput.ticker = [stock.ticker]
                userPutRequestInput.userName = RealmUtils.instance().getCurrentUser()?.userName
                userPutRequestInput.operation = "-"
                UpdateWatchlist(input: userPutRequestInput, stock:stock)
            }
        }
    }
    
    func UpdateWatchlist(input:CSUserPutRequestMethodModel, stock:StockSummary) {
        client.userPut(body: input).continueWith { (task: AWSTask<CSUserPutResponseMethodModel>?) -> AnyObject? in
            if let result = self.putUserResult(task: task) {
                //After server request perform following actions
                DispatchQueue.main.async {
                    if let userName = input.userName {
                        RealmUtils.instance().updateUserWatchlist(username: userName, watchedStocks: result.watchlist)
                        RealmUtils.instance().deleteStockSummary(stock: stock)
                        self.watchListTableView.reloadData()
                    }
                }
                return result
            }
            return nil
        }        
    }
    
    func putUserResult(task: AWSTask<CSUserPutResponseMethodModel>?) -> CSUserPutResponseMethodModel? {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stock = sender as? StockSummary {
            if let stockVC = segue.destination as? StockSummaryViewController {
                stockVC.stock = stock
            }
        }
    }
    
}

