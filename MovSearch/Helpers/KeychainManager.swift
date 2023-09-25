//
//  KeychainManager.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import KeychainAccess


struct KeychainManager {
    
    private let keychain = Keychain(service: "TMDBSwiftUI")
    
    func saveSessionID(_ sessionID:String) throws  {
        
        do {
            try keychain.set(sessionID, key: "userSessionID")
        }
        catch {
            throw KeychainError.savingError
        }
    }
    
    func deleteSessionID() throws {
        do {
            try keychain.remove("userSessionID")
        } catch {
            throw KeychainError.deletingError
        }
    }
    
    func getSessionID() throws -> String {
        var token = ""
        
        do {
            token = try keychain.get("userSessionID") ?? ""
         
        } catch  {
            throw KeychainError.gettingError
        }
        return token
    }
    
}
