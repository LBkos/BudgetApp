//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 05.07.2022.
//

import SwiftUI
import SwiftData

@main
struct BudgetAppApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.modelContext) private var context
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Card.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            WalletView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)            
        }
        .modelContainer(modelContainer)
        .modelContext(context)
    }
}

