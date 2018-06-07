//
//  CurrencyService.swift
//  Currency
//
//  Created by Bogdan Koshyrets on 2/17/18.
//  Copyright © 2018 Bohdan Koshyrets. All rights reserved.
//

import Foundation

typealias CurrencyResponse = ([String : CurrencyItem]) -> ()

class CurrencyService: BaseAPIService {

    var serviceProvider: CurrencyInterface!
    
    init(provider: CurrencyInterface) {
        serviceProvider = provider
    }
    
    func loadAllCurrentRates(success: @escaping CurrencyResponse) {
        serviceProvider.getTodayValuesForAllCurrencies { response in
            guard let arrayResponse = response as? [[String : Any]] else { return }
            var dict: [String : CurrencyItem] = [:]
            for item in arrayResponse {
                let currencyItem = CurrencyItem(nbu: item)
                if let cc = currencyItem.currencyCode {
                    dict[cc] = currencyItem
                }
            }
            success(dict)
        }
    }
}
