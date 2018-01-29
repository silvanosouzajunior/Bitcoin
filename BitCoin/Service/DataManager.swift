//
//  DataManager.swift
//  BitCoin
//
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    let priceParser = PriceParser()
    weak var delegate: DataManagerDelegate?
    
    private init() {
    }
    
    func getActualPrice() {
        if let actualPrice = LocalManager.shared.getActualPrice() {
            delegate?.updateActualPrice(actualPrice: actualPrice)
        }
        
        PriceRequester.shared.marketPlaceStats(completion: {
            actualPrice in
            
            if let actualPrice = actualPrice {
                self.delegate?.updateActualPrice(actualPrice: actualPrice)
            }
        })
    }
    
    func getMarketPrices() {
        if let marketPrices = LocalManager.shared.getMarketPrices() {
            delegate?.updateMarketPrices(marketPrices: marketPrices)
        }
        
        PriceRequester.shared.chartInfo(completion: {
            marketPrices in
            
            if let marketPrices = marketPrices {
                self.delegate?.updateMarketPrices(marketPrices: marketPrices)
            }
        })
        
        PriceRequester.shared.marketPlaceStats(completion: {
            actualPrice in
            
            if let actualPrice = actualPrice {
                self.delegate?.updateActualPrice(actualPrice: actualPrice)
            }
        })
    }
}

protocol DataManagerDelegate: class {
    func updateActualPrice(actualPrice: ActualPrice)
    func updateMarketPrices(marketPrices: [MarketPrice])
}
