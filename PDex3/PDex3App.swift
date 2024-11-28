//
//  PDex3App.swift
//  PDex3
//
//  Created by Nils Müller on 28.11.24.
//

import SwiftUI

@main
struct PDex3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
