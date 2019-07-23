//
//  StockSummaryViewController.swift
//  ClusterStocks
//
//  Created by Sushmitha on 5/27/19.
//  Copyright © 2019 Games. All rights reserved.
//

import UIKit
import RealmSwift

class StockSummaryViewController: UIViewController {
    
    var stock: StockSummary?

    @IBOutlet weak var tickerValue: UITextField!
    @IBOutlet weak var companyNameValue: UITextField!
    @IBOutlet weak var currentPriceValue: UITextField!
    @IBOutlet weak var previousCloseValue: UITextField!
    @IBOutlet weak var openValue: UITextField!
    @IBOutlet weak var daysRangeValue: UITextField!
    @IBOutlet weak var yearRangeValue: UITextField!
    @IBOutlet weak var earningsDateValue: UITextField!
    @IBOutlet weak var earningsDateField: UILabel!
    @IBOutlet weak var lastUpdatedValue: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        earningsDateValue.isHidden = true
        earningsDateField.isHidden = true
        display()
    }

    
    public func display() {
        if let stock = stock {
            tickerValue.text = stock.ticker
            companyNameValue.text = stock.companyName
            currentPriceValue.text = String(stock.currentPrice)
            previousCloseValue.text = String(stock.previousClosePrice)
            openValue.text = String(stock.openPrice)
            daysRangeValue.text = stock.daysRange
            yearRangeValue.text = stock.yearRange
            if stock.earningsDate.isEmpty {
                earningsDateField.isHidden = true
                earningsDateValue.isHidden = true
            }
            else {
                earningsDateField.isHidden = false
                earningsDateValue.isHidden = false
                earningsDateValue.text = stock.earningsDate
            }
            lastUpdatedValue.text = stock.lastUpdated
        }
    }
    
}

