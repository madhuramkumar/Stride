//
//  CacheImplementation.swift
//  Stride
//
//  Created by Madhu Ramkumar on 6/10/23.
//

//import Foundation
//
//actor InMemoryCache<V> {
//    
//    private let cache: NSCache<NSString, CacheEntry<V>> = .init()
//    private let expirationInterval: TimeInterval
//    
//    init(expirationInterval: TimeInterval) {
//        self.expirationInterval = expirationInterval
//    }
//    
//    // removes a single value from cache
//    func removeValue(forKey key: String) {
//        cache.removeObject(forKey: key as NSString)
//    }
//    
//    // removes all values from the cache
//    func removeAllValues() {
//        cache.removeAllObjects()
//    }
//    
//    // add a value to the cache
//    func setValue(_ value: V?, forKey key: String) {
//        if let value = value {
//            let expiredTimeStamp = Date().addingTimeInterval(expirationInterval)
//            let cacheEntry = CacheEntry(key: key, value: value, expiredTimeStamp: expiredTimeStamp)
//            cache.setObject(cacheEntry, forKey: key as NSString)
//        } else {
//            removeValue(forKey: key)
//        }
//    }
//    
//    // returns value of cache at certain key
//    func value(forKey key: String) -> V? {
//        guard let entry = cache.object(forKey: key as NSString) else {
//            return nil
//        }
//        
//        // remove value if cache is expired
//        guard !entry.isCacheExpired(after: Date()) else {
//            removeValue(forKey: key)
//            return nil
//        }
//        
//        return entry.value
//    }
//}
