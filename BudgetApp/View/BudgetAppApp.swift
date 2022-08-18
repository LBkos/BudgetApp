//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 05.07.2022.
//

import SwiftUI

@main
struct BudgetAppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var vm = BudgetViewModel.shared
    var body: some Scene {
        WindowGroup {
            BudgetTabView()
                .environmentObject(vm)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            .tabViewStyle(.page)
//            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            
        }
    }
}

