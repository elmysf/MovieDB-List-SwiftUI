//
//  MovSearchApp.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import SwiftUI

@main
struct MovSearchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
