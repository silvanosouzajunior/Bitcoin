//
//  PriceRequester.swift
//  BitCoin
//
//

import Foundation
import Alamofire
import SwiftyJSON

class PriceRequester {
    
    static let shared = PriceRequester()
    let priceParser = PriceParser()
    
    private init() {
    }
    
    func marketPlaceStats(completion: @escaping (_ price: ActualPrice?) -> Void) {
        let urlString = URLUtils.baseUrl + URLUtils.statsUrl
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            if let result = response.result.value, let resultDict = JSON(result).dictionaryObject {
                let actualPrice = self.priceParser.parseActualPrice(dict: resultDict)
                completion(actualPrice)
            }
        }
    }
    
    func chartInfo(completion: @escaping (_ prices: [MarketPrice]?) -> Void) {
        let urlString = URLUtils.baseUrl + URLUtils.chartsUrl
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            if let result = response.result.value, let resultDict = JSON(result).dictionaryObject {
                LocalManager.shared.deleteAllData(entity: "MarketPrice")
                let chartPrices = self.priceParser.parseChartPrices(dict: resultDict)
                completion(chartPrices)
            }
        }
    }}
