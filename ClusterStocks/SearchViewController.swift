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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        fieldStackView.isHidden = true
        valueStackView.isHidden = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("Searching...\(String(describing: searchBar.text))")
        
        if let searchText = searchBar.text, let stock = StockSummaryUtils.instance().findAll().first(where: { $0.ticker == searchText
        }) {
            tickerValue.text = stock.ticker
            companyNameValue.text = stock.companyName
            currentPriceValue.text = String(stock.currentPrice)
            fieldStackView.isHidden = false
            valueStackView.isHidden = false
        } else {
            fieldStackView.isHidden = true
            valueStackView.isHidden = true
        }
            
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancelling Search...\(String(describing: searchBar.text))")
        searchBar.text = ""
        fieldStackView.isHidden = true
        valueStackView.isHidden = true
    }
}
