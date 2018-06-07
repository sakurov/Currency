//
//  InterfaceController.swift
//  CurrencyWatchApp Extension
//
//  Created by Bogdan Koshyrets on 2/18/18.
//  Copyright © 2018 Bohdan Koshyrets. All rights reserved.
//

import WatchKit
import Foundation

enum State {
    case loading
    case normal
}


class InterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    var currencyArray:   [CurrencyItem]
    var providerType:    ProviderType
    let currencyService: IdeilService
    
    var state: State = .normal {
        didSet {
            switch state {
            case .loading: self.updateHeaderCell()
            case .normal:  self.setupCells()
            }
        }
    }
    
    override init() {
        self.providerType = .goverla
        self.currencyArray = []
        self.currencyService = IdeilService()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setTitle("Currency")
        self.setupCells()
        self.loadRemoteData()
        self.addMenuItem(with: .repeat, title: "Refresh", action: #selector(refreshMenuAction))
    }

    override func didAppear() {
        super.didAppear()
        
        self.updateHeaderCell()
    }

    @objc private func refreshMenuAction() {
        self.loadRemoteData()
    }

    fileprivate func loadRemoteData() {
        
        self.state = .loading
        
        func result(_ result: [CurrencyItem]?) {
            if let array = result {
                self.currencyArray = array
                self.state = .normal
            }
        }
        
        let currencies: [CurrencyType] = [.usd, .eur, .gbp, .pln, .cad, .aud]
        self.currencyService.getValues(for: currencies, from: providerType, success: result)
    }
    
    func setupCells() {
        self.setupRowTypes()
        
        for item in 0 ..< table.numberOfRows {
            if let row = self.table.rowController(at: item) as? CurrencyRowController {
                let currencyItem = currencyArray[item - 1]
                row.configureView(with: currencyItem)
            } else if let _ = self.table.rowController(at: item) as? UpdatedRowController {
                self.updateHeaderCell()
            }
        }
    }
    
    fileprivate func setupRowTypes() {
        let rowTypes = ["UpdatedRowController"] + currencyArray.map({ _ in "CurrencyRowController" })
        table.setRowTypes(rowTypes)
    }
    
    func updateHeaderCell() {
        guard let row = self.table.rowController(at: 0) as? UpdatedRowController else { return }
        switch state {
        case .normal:
            row.updatedLabel.setText("Updated " + currencyService.lastUpdated())
        case .loading:
            row.updatedLabel.setText("Loading")
        }
    }
}

class CurrencyRowController: NSObject {
    @IBOutlet weak var titleLabel:   WKInterfaceLabel!
    @IBOutlet weak var rateAskLabel: WKInterfaceLabel!
    @IBOutlet weak var rateBidLabel: WKInterfaceLabel!
    
    func configureView(with model: CurrencyItem) {
        self.titleLabel.setText(model.currencyCode)
        self.rateAskLabel.setText(String(format: "%.2f", model.rateAsk!))
        self.rateBidLabel.setText(String(format: "%.2f", model.rateBid!))
        self.rateAskLabel.setTextColor(colorForDiff(value: model.diffAsk!))
        self.rateBidLabel.setTextColor(colorForDiff(value: model.diffBid!))
    }
    
    private func colorForDiff(value: Double) -> UIColor {
        enum DiffColor {
            case green, white, red
            
            func uiColor() -> UIColor {
                switch self {
                case .green: return UIColor.green
                case .white: return UIColor.white
                case .red:   return UIColor.red
                }
            }
        }
        
        if value > 0.0 {
            return DiffColor.green.uiColor()
        } else if value < 0.0 {
            return DiffColor.red.uiColor()
        }
        return DiffColor.white.uiColor()
    }
        
        
}

class UpdatedRowController: NSObject {
    @IBOutlet weak var updatedLabel: WKInterfaceLabel!
}
