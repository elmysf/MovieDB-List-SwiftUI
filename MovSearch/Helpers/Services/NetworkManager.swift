//
//  NetworkManager.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import AsyncCompatibilityKit
import AuthenticationServices
import Combine
import Network

final class NetworkManager:NSObject {
    
    @Published var noInternet: Bool = false
    @Published var noWifinoCelularData = false
    
    private let monitor = NWPathMonitor()
    
    
    override init() {
        super.init()
        detectWIFIandData()
    }

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 5
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }()
    
    func makeHTTPRequest<T:Decodable>(url: URLRequest) async throws-> T {
        
        var data: Data
        var response: URLResponse

        do {
            (data, response) = try await session.data(for: url)
            
        } catch {
            throw MovieServiceError.badInternet
        }
        guard (response as? HTTPURLResponse)?.statusCode == 200 || (response as? HTTPURLResponse)?.statusCode == 201 else {
            
            throw MovieServiceError.invalidServerResponse
        }
        do {
            let dataDecoded = try JSONDecoder().decode(T.self, from: data)
            
            return dataDecoded
        } catch  {
            throw MovieServiceError.failedDecode
        }
        
    }
}

extension NetworkManager{
    func signInAsync(requestToken: String) async throws -> String {
        
        try await withCheckedThrowingContinuation { (continuation:CheckedContinuation<String, Error>) in
            
            self.webAuth(requestToken: requestToken) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    private func webAuth(requestToken: String,completion: @escaping (Result<String, Error>) -> Void) {
        
        let scheme = "exampleauth"
        let sessionAuth = ASWebAuthenticationSession(url: URL(string: EndPoint.authStep2+requestToken+"?redirect_to=exampleauth://auth")!, callbackURLScheme: scheme)
        { callbackURL, error in
            
            guard error == nil, let callbackURL = callbackURL else {
                completion(.failure(OthersErrors.userCanceledAuth))
                return
            }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard ((queryItems?.filter({ $0.name == "denied" }).first?.value) != nil) == false else{
                completion(.failure(OthersErrors.userDeniedAuth))
                return
            }
            let token:String? = queryItems?.filter({ $0.name == "request_token" }).first?.value
            guard let token = token else{
                completion(.failure(OthersErrors.cantGetToken))
                return
            }
            completion(.success(token))
        }
        sessionAuth.presentationContextProvider = self
        sessionAuth.start()
    }
    
}

extension NetworkManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

extension NetworkManager {
    
    private func detectWIFIandData() {
        
        monitor.start(queue: .main)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied{
                print("WE HAVE WIFI/DATA")
                self.noWifinoCelularData = false
                self.noInternet = false
            }else{
                print("NO WIFI/DATA")
                self.noWifinoCelularData = true
                self.noInternet = true
            }
        }
    }
}

extension NetworkManager: URLSessionTaskDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("NO INTERNET")
        
        noInternet = true
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        
        guard task.error == nil, let metric = metrics.transactionMetrics.first?.resourceFetchType else {
            print("THERE WAS A TASK ERROR THAT IS NOT NIL")
            noInternet = true
            return
        }
        
        
        switch metric{
        case .unknown:
            print("RESOURCE OBTAINED FROM UNKNOW")
            break
        case .networkLoad, .serverPush:
            print("RESOURCE OBTAINED FROM NETWORK LOAD, SERVERPUSH")
            noInternet = false
        case .localCache:
            print("RESOURCE OBTAINED FROM CACHE")
            break
        @unknown default:
            print("RESOURCE OBTAINED FROM DEFAULT")
            break
        }
    }
}

