//
//  SearchViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha on 6/27/19.
//  Copyright © 2019 Games. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var fieldStackView: UIStackView!
    @IBOutlet weak var valueStackView: UIStackView!
    @IBOutlet weak var tickerValue: UITextField!
    @IBOutlet weak var companyNameValue: UITextField!
    @IBOutlet weak var currentPriceValue: UITextField!
    @IBOutlet weak var saveToWatchlist: UIButton!
    let client = CSClusterStockAPIClient.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        fieldStackView.isHidden = true
        valueStackView.isHidden = true
        saveToWatchlist.isHidden = true
        
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
    
    func getStock(ticker: String){
        client.stockGet(ticker: ticker).continueWith{(task: AWSTask<CSStockGetResponseMethodModel>?) -> AnyObject? in
            if let result = self.getStockGetResult(task: task) {
                DispatchQueue.main.async {
                    self.tickerValue.text = result.ticker
                    self.companyNameValue.text = result.nameOfTheListing
                    self.currentPriceValue.text = result.currentPrice
                    self.fieldStackView.isHidden = false
                    self.valueStackView.isHidden = false
                    self.saveToWatchlist.isHidden = false
                }
                return result
            }
            //Handle invalid ticker request
            //Hide for next ticker
            return nil
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("Searching...\(String(describing: searchBar.text))")
        if let potentialTickerSymbol = searchBar.text {
            getStock(ticker: potentialTickerSymbol)
        }
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancelling Search...\(String(describing: searchBar.text))")
        searchBar.text = ""
        fieldStackView.isHidden = true
        valueStackView.isHidden = true
        saveToWatchlist.isHidden = true
        tickerValue.text = ""
        companyNameValue.text = ""
        currentPriceValue.text = ""
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
    
    func updateWatchlist(input:CSUserPutRequestMethodModel) {
        //AWS puts the task in a dispatch queue. The continue with block (closure) is also put into the same queue.
        //After AWS task is completed, this closure is called
        client.userPut(body: input).continueWith { (task: AWSTask<CSUserPutResponseMethodModel>?) -> AnyObject? in
            if let result = self.putUserResult(task: task) {
                //main queue runs only in main thread. Main thread always runs serially. All realm operations access the DB and modify them
                //These operations need to be done sequrntially
                DispatchQueue.main.async {
                    if let userName = input.userName {
                        RealmUtils.instance().updateUserWatchlist(username: userName, watchedStocks: result.watchlist)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                return result
            }
            return nil
        }
    }
    
    @IBAction func saveToWatchlistClicked(_ sender: Any) {
        if let userPutRequestInput = CSUserPutRequestMethodModel() {
            if let ticker = tickerValue.text {
                userPutRequestInput.ticker = [ticker]
                userPutRequestInput.userName = RealmUtils.instance().getCurrentUser()?.userName
                userPutRequestInput.operation = "+"
                updateWatchlist(input: userPutRequestInput)
            }
        }
    }
}
