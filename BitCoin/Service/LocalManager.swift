//
//  LocalManager.swift
//  BitCoin
//
//

import UIKit
import CoreData

class LocalManager {
    
    static let shared = LocalManager()
    let priceParser = PriceParser()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {
    }
    
    func save() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func deleteAllData(entity: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entity))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
}

extension LocalManager {
    func getActualPrice() -> ActualPrice? {
        do {
            if let prices = try context.fetch(ActualPrice.fetchRequest()) as? [ActualPrice] {
                return prices.first
            }
        } catch {
            print("Fetching Failed")
        }
        return nil
    }
    
    func updateActualPrice(timestamp: Int, price: Double) -> ActualPrice {
        var actualPrice = getActualPrice()
        
        if actualPrice == nil {
            actualPrice = ActualPrice(context: context)
        }
        
        actualPrice?.timestamp = Int64(timestamp)
        actualPrice?.price = price
        
        self.save()
        return actualPrice!
    }
}

extension LocalManager {
    func getMarketPrices() -> [MarketPrice]? {
        do {
            if let prices = try context.fetch(MarketPrice.fetchRequest()) as? [MarketPrice] {
                return prices
            }
        } catch {
            print("Fetching Failed")
        }
        return nil
    }
    
    func createMarketPrice(timestamp: Int, price: Double) -> MarketPrice {
        let marketPrice = MarketPrice(context: context)
        
        marketPrice.timestamp = Int64(timestamp)
        marketPrice.price = price
        
        self.save()
        return marketPrice
    }
}
