//
//  CollectionExtensions.swift
//  BitCoin
//
//

import Foundation

extension Collection {
    func find(_ predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Self.Iterator.Element? {
        return try index(where: predicate).map({self[$0]})
    }
}
