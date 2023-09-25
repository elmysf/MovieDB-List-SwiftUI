//
//  Errors.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation

enum MovieServiceError: Error, LocalizedError{
    case invalidServerResponse
    case failedDecode
    case badInternet
    case failedtoRequestNewToken
    
    var errorDescription: String?{
        switch self {
        case .invalidServerResponse:
            return NSLocalizedString("The server is having problems", comment: "")
        case .failedDecode:
            return NSLocalizedString("There was an error decoding, try again.", comment: "")
        case .badInternet:
            return NSLocalizedString("Apparently there are Internet connection problems", comment: "")
        case .failedtoRequestNewToken:
            return NSLocalizedString("There was an authentication error. Please try again", comment: "")
        }
    }
}

enum OthersErrors: Error, LocalizedError {
    case cantGetToken
    case cantCreateURL
    case userDeniedAuth
    case userCanceledAuth
    
    var errorDescription: String?{
        switch self {
        case .cantGetToken:
            return NSLocalizedString("The authorization token could not be obtained. Please try again", comment: "")
        case .cantCreateURL:
            return NSLocalizedString("URL could not be created", comment: "")
        case .userDeniedAuth:
            return NSLocalizedString("User did not authorize authentication", comment: "")
        case .userCanceledAuth:
            return NSLocalizedString("", comment: "")
        }
    }
}

enum KeychainError: Error, LocalizedError{
    
    case savingError, gettingError, deletingError
    
    var errorDescription: String?{
        switch self {
        case .savingError:
            return NSLocalizedString("The session could not be saved. Try again", comment: "")
        case .gettingError:
            return NSLocalizedString("There was an error obtaining your session", comment: "")
        case .deletingError:
            return NSLocalizedString("The session could not be deleted. Please try again.", comment: "")
        }
    }
    
    
}

enum CoreDataError: Error, LocalizedError{
    
    case persistentHistoryChangeError, batchInsertError, deletingError, savingError
    
    var errorDescription: String?{
        switch self {
        case .persistentHistoryChangeError:
            return NSLocalizedString("persistent History Change Error", comment: "")
        case .batchInsertError:
            return NSLocalizedString("There was an error in the Core Data insertion", comment: "")
        case .savingError:
            return NSLocalizedString("There was an error in the Core Data insertion", comment: "")
        case .deletingError:
            return NSLocalizedString("The session could not be deleted. Please try again.", comment: "")
        }
    }
}
