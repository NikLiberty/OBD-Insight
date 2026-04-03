//
//  OBD_Insight_V2_0App.swift
//  OBD Insight V2.0
//
//  Created by Никита on 27.03.2026.
//

import SwiftUI

@main
struct OBD_Insight_V2_0App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
