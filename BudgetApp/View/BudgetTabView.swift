//
//  BudgetTabView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 18.08.2022.
//

import SwiftUI

struct BudgetTabView: View {
    @EnvironmentObject var vm: BudgetViewModel
    var body: some View {
        TabView(selection: $vm.selected) {
            BudgetView()
                .tabItem {
                    Label("All", systemImage: "plusminus.circle.fill")
                }
                .tag(1)
            BudgetView()
                .tabItem {
                    Label("Expense", systemImage: "minus.circle.fill")
                }
                .tag(2)
            BudgetView()
                .tabItem {
                    Label("Income", systemImage: "plus.circle.fill")
                }
                .tag(3)
        }
    }
}

struct BudgetTabView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetTabView()
    }
}
