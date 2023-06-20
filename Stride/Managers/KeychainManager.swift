//
//  KeychainManager.swift
//  Stride
//
//  Created by Madhu Ramkumar on 6/15/23.
//

import Foundation

// helps save access and refresh tokens in the keychain for easy retrieval and saving
final class KeychainManager {
    let account = "spotify"
    let service = "token"
    
    // singleton
    static let standard = KeychainManager()
    private init() {}
    
    // saves access token to keychain and updates access token with new token
    func save(_ data: Data, service: String, account: String) {
        
        // create query
        let query = [
            kSecValueData: data, // key that represents data being saved to keychain
            kSecClass: kSecClassGenericPassword, // key that represents type of data being saved, kSecClassGenericPassword indicates the saving of a generic password item
            kSecAttrService: service, // use these keys to retrieve saved data from keychain later on
            kSecAttrAccount: account,
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        // if access token is getting saved for first time
        if (status != errSecSuccess) {
            // print out error
            print ("Error: \(status)")
        }
        
        // updating access token
        if (status == errSecDuplicateItem) {
            // Item already exists, so update it
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            // update existing item
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    // reads data from keychain
    func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    // generic read and save functions that support any object type with a data type that conforms to Codable protocol
    func save<T>(_ item: T, service: String, account: String) where T : Codable {
        
        do {
            // Encode as JSON and save to keychain
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)
        } catch {
            assertionFailure("Fail to encode item to keychain: \(error)")
        }
    }
    
    func read<T>(service: String, account: String, type: T.Type) ->T? where T : Codable {
        
        // read item from keychain using previous read func
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
}
