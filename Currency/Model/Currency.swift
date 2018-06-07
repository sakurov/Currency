//
//  Currency.swift
//  Currency
//
//  Created by Bogdan Koshyrets on 2/17/18.
//  Copyright © 2018 Bohdan Koshyrets. All rights reserved.
//

import Foundation

struct CurrencyItem: Codable {
    let r030: Int?
    let name: String?
    let rateAsk: Double?
    let rateBid: Double?
    let diffAsk: Double?
    let diffBid: Double?
    let currencyCode: String?
    let exchangeDate: String?
    
    init(nbu dict: [String: Any]) {
        r030         = dict["r030"]         as? Int
        name         = dict["txt"]          as? String
        rateAsk      = dict["rate"]         as? Double
        rateBid      = dict["rate"]         as? Double
        diffAsk      = 0.0
        diffBid      = 0.0
        currencyCode = dict["cc"]           as? String
        exchangeDate = dict["exchangedate"] as? String
    }
    
    init(goverla dict: [String: Any]) {
        r030         = dict["r030"]      as? Int
        name         = dict["txt"]       as? String
        rateAsk      = dict["ask"]       as? Double
        rateBid      = dict["bid"]       as? Double
        diffAsk      = dict["diff_ask"]  as? Double
        diffBid      = dict["diff_bid"]  as? Double
        currencyCode = dict["currency"]  as? String
        exchangeDate = dict["timestamp"] as? String
    }
}

