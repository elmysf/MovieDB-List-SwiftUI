//
//  MovSearchApp.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import SwiftUI
import NukeUI

@main
struct MovSearchApp: App {
    @StateObject private var movieVM: MoviesViewModel
    @StateObject private var userVM: UserViewModel
    @StateObject private var networkViewModel: NetworkViewModel

    init() {
       let keychainManager = KeychainManager()
       let networkManager = NetworkManager()
        
        _movieVM = StateObject(wrappedValue: MoviesViewModel(service: networkManager, keychainM: keychainManager))
        _userVM = StateObject(wrappedValue: UserViewModel(service: networkManager, keychainM: keychainManager))
        _networkViewModel = StateObject(wrappedValue: NetworkViewModel(networkMg: networkManager))
        
        ImagePipeline.shared = ImagePipeline(configuration: .withDataCache)
    }

    var body: some Scene {
        WindowGroup {
                ContentView()
                    .environmentObject(movieVM)
                    .environmentObject(userVM)
                    .environmentObject(networkViewModel)
                    .environment(\.managedObjectContext, PersistenceController2.shared.container.viewContext)
        }
    }
}
