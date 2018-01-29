//
//  PriceParser.swift
//  BitCoin
//
//

import Foundation

class PriceParser {

    func parseActualPrice(dict: [String: Any]) -> ActualPrice {
        var price: Double = 0
        var timestamp: Int = 0
        
        if let priceFromDict = dict["market_price_usd"] as? Double {
            price = priceFromDict
        }
        
        if let timestampFromDict = dict["timestamp"] as? Int {
            timestamp = timestampFromDict
        }
        
        let actualPrice = LocalManager.shared.updateActualPrice(timestamp: timestamp, price: price)
        return actualPrice
    }
    
    func parseMarketPrice(dict: [String: Any]) -> MarketPrice {
        var price: Double = 0
        var timestamp: Int = 0
        
        if let priceFromDict = dict["y"] as? Double {
            price = priceFromDict
        }
        
        if let timestampFromDict = dict["x"] as? Int {
            timestamp = timestampFromDict
        }
        
        let marketPrice = LocalManager.shared.createMarketPrice(timestamp: timestamp, price: price)
        return marketPrice
    }
    
    func parseChartPrices(dict: [String: Any]) -> [MarketPrice] {
        var chartPrices = [MarketPrice]()
        if let values = dict["values"] as? [[String: Any]] {
            for marketDict in values {
                let marketPrice = self.parseMarketPrice(dict: marketDict)
                chartPrices.append(marketPrice)
            }
        }
        return chartPrices
    }
}
