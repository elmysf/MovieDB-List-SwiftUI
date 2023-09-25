//
//  NetworkViewModel.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation

final class NetworkViewModel: ObservableObject{
    @Published var noInternet: Bool = false
    @Published var noWifinoCelularData: Bool = false
    
    init(networkMg: NetworkManager) {
        
        networkMg.$noInternet
            .assign(to: &$noInternet)
        
        networkMg.$noWifinoCelularData
            .assign(to: &$noWifinoCelularData)

    }
    
}
