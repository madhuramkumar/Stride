//
//  CacheEntry.swift
//  Stride
//
//  Created by Madhu Ramkumar on 6/10/23.
//

import Foundation

// using final ensures that class cannot be subclassed
final class CacheEntry<V> {
    
    let key: String
    let value: V
    let expiredTimeStamp: Date
    
    init (key: String, value: V, expiredTimeStamp: Date) {
        self.key = key
        self.value = value
        self.expiredTimeStamp = expiredTimeStamp
    }
    
    // returns true if cache is expired based on expiredTimeStamp
    func isCacheExpired(after date: Date = .now) -> Bool {
        date > expiredTimeStamp
    }
}
