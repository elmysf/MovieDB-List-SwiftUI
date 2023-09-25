//
//  Constants.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import Nuke


struct Constants{
    
    static let gravatarURL = "https://www.gravatar.com/avatar/"
    
    struct ImageFetch {
        static let base_url      = "https://image.tmdb.org/t/p/"
        static let size92        = "w92"
        static let size154       = "w154"
        static let size185       = "w185"
        static let size342       = "w342"
        static let size500       = "w500"
        static let size780       = "w780"
        static let originalSize  = "original"
        
    }
    
    static func onCompletionLazyImage(networkVM: NetworkViewModel) -> (Result<ImageResponse, Error>)->() {
        return { (result: Result<ImageResponse, Error>) in
            
            switch result {
                
            case .success(let sucess):
                if sucess.cacheType == .memory || sucess.cacheType == .disk {
                    
                }else{
                    networkVM.noInternet = false
                }
                
                case .failure(let error):
                let error2 = error as! Nuke.ImagePipeline.Error
                
                if error2.description.contains("Response status code was unacceptable"){
                    print("Error in the image URL")
                    networkVM.noInternet = false
                    return
                }
                
                if let error2 = error2.dataLoadingError as? URLError{
                    switch error2.code{
                    case .dataNotAllowed:
                        print("NO INTERNET FOR NO DATA?")
                        networkVM.noInternet = true
                    case .notConnectedToInternet:
                        print("NO INTERNET URL?")
                        networkVM.noInternet = true
                    default:
                        break
                    }
                }
            }
        }
    }
}



