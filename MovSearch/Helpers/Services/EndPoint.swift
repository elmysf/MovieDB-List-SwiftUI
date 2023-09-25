//
//  EndPoint.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation



enum EndPoint {
    
    private static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "acd144f45c09da7914e99ce2e78e1bb3"
    static let authStep2 = "https://www.themoviedb.org/authenticate/"
    
    static func createURLRequest(url: Route, method: HTTPMethod, query: [String: String]? = nil, parameters: [String: Any]? = nil) throws -> URLRequest {
        
        
        //URLs
        let urlString = EndPoint.baseURL + url.rawValue
        let URL = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: URL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue

        if let query = query {
            var urlComponent = URLComponents(string: urlString)
            urlComponent?.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
            urlRequest.url = urlComponent?.url
        }

        if let parameters = parameters {
            do{
                let bodyData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                //let bodyData = try JSONEncoder().encode(parameters)
                urlRequest.httpBody = bodyData
            }catch{
                throw OthersErrors.cantCreateURL
            }
        }
        return urlRequest
    }
}


enum HTTPMethod: String {
    case GET, POST, DELETE
}

enum Route: Equatable {
    case popularMovies
    case accountInfo
    case authStep1
    case authStep3
    case logOut
    case setfavoriteMovie(String)
    case getFavoritesMovies(String)
    case topRatedMovies
    case upcomingMovies
    case nowPlayingMovies
    case movie(String)
    case searchMovie
    
    
    var rawValue: String {
        switch self {
        case .setfavoriteMovie(let accID):
             return "account/\(accID)/favorite"
        case .popularMovies:
             return "movie/popular"
        case .accountInfo:
            return "account"
        case .authStep1:
            return "authentication/token/new"
        case .authStep3:
            return "authentication/session/new"
        case .logOut:
            return "authentication/session"
        case .getFavoritesMovies(let accID):
            return "account/\(accID)/favorite/movies"
        case .topRatedMovies:
            return "movie/top_rated"
        case .movie(let id):
            return "movie/\(id)"
        case .searchMovie:
            return"search/movie"
        case .upcomingMovies:
            return "movie/upcoming"
        case .nowPlayingMovies:
            return "movie/now_playing"
        }
    }
    
}
