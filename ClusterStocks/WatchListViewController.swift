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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //internal parameter - forRowAt and indexpath are alias
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let stock = self.allStocks[indexPath.row]
            if let userPutRequestInput = CSUserPutRequestMethodModel() {
                userPutRequestInput.ticker = [stock.ticker]
                userPutRequestInput.userName = "a"//fetch username
                userPutRequestInput.operation = "-"
                UpdateWatchlist(input: userPutRequestInput, stock:stock)
                RealmUtils.instance().deleteStockSummary(stock: stock)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
        }
    }
    
    func UpdateWatchlist(input:CSUserPutRequestMethodModel, stock:StockSummary) {
        client.userPut(body: input).continueWith { (task: AWSTask<CSUserPutResponseMethodModel>?) -> AnyObject? in
            if let result = self.putUserResult(task: task) {
                DispatchQueue.main.async {
                    let user = User()
                    user.userName = "a"
                    if let watchedStocks = result.watchlist{
                    user.watchList.append(objectsIn: watchedStocks)
                    }
                    RealmUtils.instance().saveUser(user: user)
                    RealmUtils.instance().deleteStockSummary(stock: stock)
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

    public func populateStockSummaryList() {
        // Get all the stock summaries
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stock = sender as? StockSummary {
            if let stockVC = segue.destination as? StockSummaryViewController {
                stockVC.stock = stock
            }
        }
    }
    
}

