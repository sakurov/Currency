//
//  IdeilService.swift
//  Currency
//
//  Created by Bogdan Koshyrets on 3/8/18.
//  Copyright © 2018 Bohdan Koshyrets. All rights reserved.
//

import Foundation

enum ProviderType: String {
    case goverla
    case niko
    case aval
    case cashlutsk
    case privatbank_card
    case privatbank_cash
}

class IdeilService: BaseAPIService {
    func getTodayValuesForAllCurrencies(from provider: ProviderType, success: ((Any) -> Void)?) {
        let baseURL = Host.ideil.baseURL
        
        sendRequest(baseURL) { response in
            if let dict = response as? [String : Any],
                let rates = dict["rates"] as? [String : Any],
                let providerRates = rates[provider.rawValue.lowercased()] as? [String : Any] {
                success?(providerRates)
            }
        }
    }
    
    func getValues(for currencyTypes: [CurrencyType], from provider: ProviderType, success: ResponseCurrencyArray?) {
        getTodayValuesForAllCurrencies(from: provider) { response in
            var currenciesToReturn = [CurrencyItem]()
            
            if let rates = response as? [String : Any] {
                for currencyType in currencyTypes {
                    let currencyDict = rates[currencyType.rawValue.uppercased()] as? [String : Any]
                    if let currencyDict = currencyDict {
                        let currencyObject = CurrencyItem.init(goverla: currencyDict)
                        currenciesToReturn.append(currencyObject)
                    }
                }
            }
            success?(currenciesToReturn)
        }
    }
}
