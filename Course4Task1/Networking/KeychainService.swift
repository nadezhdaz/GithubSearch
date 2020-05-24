//
//  KeychainService.swift
//  Course4Task1
//
//  Created by Надежда Зенкова on 20.05.2020.
//  Copyright © 2020 Надежда Зенкова. All rights reserved.
//

import Foundation
//
// MARK: - Keychain Service
//

/// Stores user password for Github server
class KeychainService {
    
    static let server = "https://github.com"
    
    func saveCredentials(credentials: UserCredentials) -> Bool {
        let account = credentials.account
        let password = credentials.password.data(using: String.Encoding.utf8)!
        
        if readPassword(server: KeychainService.server) != nil {
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = password as AnyObject
            
            
            let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrAccount as String: account,
                                        kSecAttrServer as String: KeychainService.server,
                                        kSecValueData as String: password]
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: KeychainService.server,
                                    kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        print("password saved in keychain")
        return status == noErr
    }
    
    func readPassword(server: String) -> UserCredentials? {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
       
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String : AnyObject],
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8),
            let account = item[kSecAttrAccount as String] as? String else {
                return nil
        }
        print("password read from keychain")
        let credentials = UserCredentials(account: account, password: password)
        return credentials
    }
    
}
