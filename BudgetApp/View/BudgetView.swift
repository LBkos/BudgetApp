//
//  BudgetView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 05.07.2022.
//

import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var vm: BudgetViewModel
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $vm.selected, label: Text("Picker")) {
                    Text("All").tag(1)
                    Text("Spends").tag(2)
                    Text("Income").tag(3)
                    
                }
                .pickerStyle(.segmented)
                .padding()
                if vm.budgets.isEmpty {
                    Spacer()
                    Text("No Budget")
                        .font(.title)
                    Spacer()
                } else {
                    List {
                        ForEach(vm.filteredBudget()) { item in
                            HStack {
                                Text(vm.formatter.string(from: NSNumber(value: Double(item.sum ?? "") ?? 0.0)) ?? "")
                                     Spacer()
                                Image(systemName: item.type == "income" ? "plus.circle.fill" : "minus.circle.fill")
                                    .foregroundColor(item.type == "income" ? .green : .red)
                            }
                        }
                        .onDelete(perform: vm.delete)
                    }
                    
                }
                NavigationLink("Add new") {
                    CreateNewView()
                }
                .buttonStyle(BudgetButtonStyle())
                .padding(.bottom)
            }
            .navigationTitle(Text(vm.allSum()))
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView().environmentObject(BudgetViewModel())
    }
}


struct BudgetButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(configuration.isPressed ? Color.blue.opacity(0.6) : Color.blue)
            .cornerRadius(8)
            .padding(.horizontal)
    }
}
