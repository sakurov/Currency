//
//  MainController.swift
//  Currency
//
//  Created by Bogdan Koshyrets on 2/17/18.
//  Copyright © 2018 Bohdan Koshyrets. All rights reserved.
//

import UIKit

class MainController: UITableViewController {
    
    var currencyArray: [CurrencyItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    
    weak var timer: Timer?
    
    var currencyService = NBUService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Currencies"
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)

//        self.loadSavedData()
        self.loadRemoteData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.loadRemoteData()
    }
    
    fileprivate func loadSavedData() {
        /*
        if let array = currencyService.restoreFromUserDeafults() {
            self.currencyArray = array
            self.updateTitle()
        }
        */
    }
    
    fileprivate func loadRemoteData() {
        
        func handleResponce(_ result: [CurrencyItem]?) {
            if let result = result {
                self.currencyArray = result
            }

            self.updateTitle()
            self.refreshControl?.endRefreshing()
            self.startTimer()
        }
        
        self.currencyService.getValues(for: [.usd, .eur, .gbp, .pln, .aud, .cad], success: handleResponce)
    }
    
    private func updateTitle() {
        DispatchQueue.main.async {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Updated \(self.currencyService.lastUpdated())", attributes: [:])
        }

    }
    
    @objc private func refreshData() {
        self.refreshControl?.beginRefreshing()
        self.loadRemoteData()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            if let weakSelf = self {
                DispatchQueue.main.async {
                    weakSelf.refreshControl?.attributedTitle = NSAttributedString(string: "Updated \(weakSelf.currencyService.lastUpdated())", attributes: [:])
                }
            }
        })
    }
}

extension MainController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = currencyArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyMainCell", for: indexPath) as! CurrencyMainCell
        cell.currencyCodeLabel.text = item.currencyCode
        cell.currencyNameLabel.text = item.name
        cell.valueLabel.text = item.rateAsk?.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
}
