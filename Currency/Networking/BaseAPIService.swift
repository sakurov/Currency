//
//  BaseAPIService.swift
//  Currency
//
//  Created by Bogdan Koshyrets on 2/17/18.
//  Copyright © 2018 Bohdan Koshyrets. All rights reserved.
//

import Foundation
import Alamofire

typealias RawResponse = ([[String: Any]]) -> ()
typealias ResponseCurrency = (CurrencyItem) -> ()
typealias ResponseCurrencyArray = ([CurrencyItem]) -> ()

let currencyLastUpdatedDate = "currencyLastUpdatedDate"
let lastSavedCurrencies = "lastSavedCurrencies"

enum Host {
    case nbu
    case ideil
    
    var baseURL: String {
        switch self {
        case .nbu:   return "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange"
        case .ideil: return "https://rates.ideil.com/api/latest.json"
        }
        
    }
}

enum CurrencyType: String {
    case usd
    case eur
    case gbp
    case pln
    case cad
    case aud
}

protocol CurrencyInterface {
    func getTodayValuesForAllCurrencies(success: ((Any) -> Void)?)
//    func getValue(for currency: Currency, at date: Date, success: ResponseCurrency?)
//    func getTodayValue(for currency: Currency, success: ResponseCurrency?)
    func getValues(for currencies: [CurrencyType], success: ResponseCurrencyArray?)
}

class NBUService: BaseAPIService {
    func getTodayValue(for currency: CurrencyType, success: ResponseCurrency?) {
        getValue(for: currency, success: success)
    }
    
    func getTodayValuesForAllCurrencies(success: ((Any) -> Void)?) {
        let url = Host.nbu.baseURL + "?json"
        
        sendRequest(url) { response in
            success?(response)
        }
    }
    
    func getValue(for currency: CurrencyType, success: ResponseCurrency?) {
        let currencyString = "valcode=" + currency.rawValue
        let url = Host.nbu.baseURL + "?" + currencyString + "&json"
        
        sendRequest(url) { response in
            guard let dictionary = response as? [[String : Any]] else { return }
            guard dictionary.count == 1, let item = dictionary.first else {
                return
            }
            
            let currencyItem = CurrencyItem(nbu: item)
            success?(currencyItem)
        }
    }
    
    func getValues(for currencies: [CurrencyType], success: ResponseCurrencyArray?) {
        getTodayValuesForAllCurrencies { response in
            var array: [CurrencyItem] = []

            guard let responseArray = response as? [[String : Any]] else { return }
            
            for item in responseArray {
                let currency = CurrencyItem(nbu: item)
                if let cc = currency.currencyCode, let cur = CurrencyType.init(rawValue: cc.lowercased()) {
                    if currencies.contains(cur) {
                        array.append(currency)
                    }
                }
            }
            success?(array)
        }
    }
}

class BaseAPIService {
    
    private let sessionManager = SessionManager()
    private var request: DataRequest?
    
    @discardableResult
    func sendRequest(_ url: String, success: @escaping ((Any) -> Void) ) -> DataRequest? {
        self.request = self.sessionManager.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    UserDefaults.standard.set(Date(), forKey: currencyLastUpdatedDate)
                    success(data)
                case .failure: ()
                    print("Error!!1")
                }
        }
        return self.request
    }
    
    func saveDateOfFetchingToUserDefaults() {
        UserDefaults.standard.set(Date(), forKey: currencyLastUpdatedDate)
        UserDefaults.standard.synchronize()
    }
    
    func saveToUserDefaults(array: [CurrencyItem]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(array), forKey: lastSavedCurrencies)
    }
    
    func restoreFromUserDeafults() -> [CurrencyItem]? {
        if let data = UserDefaults.standard.value(forKey: lastSavedCurrencies) as? Data {
            return try? PropertyListDecoder().decode(Array<CurrencyItem>.self, from: data)
        }
        return nil
    }
    
    func lastUpdated() -> String {
        let now = Date()
        
        guard let dateLastUpdated = UserDefaults.standard.object(forKey: currencyLastUpdatedDate) as? Date else { return "Never" }
        if now.secondsSince(dateLastUpdated) < 5.0 { return "just now" }
        if now.secondsSince(dateLastUpdated) < 60.0 { return "seconds ago" }
        if now.secondsSince(dateLastUpdated) < 120.0 { return "a minute ago" }
        if now.minutesSince(dateLastUpdated) < 4.0 { return "minutes ago" }
        if now.minutesSince(dateLastUpdated) < 7.0 { return "several minutes ago" }
        if dateLastUpdated.isInToday { return dateLastUpdated.timeString() }
        if dateLastUpdated.isInYesterday { return "yesterday at \(dateLastUpdated.timeString(ofStyle: .short))" }
        return dateLastUpdated.dateTimeString(ofStyle: .short)
    }

}
