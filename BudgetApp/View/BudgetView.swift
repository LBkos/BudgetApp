//
//  BudgetView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 05.07.2022.
//

import SwiftUI

struct BudgetView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: BudgetViewModel
    @State var isDragging = false
    @State var showAdd = false
    init() {
        UITableView.appearance().sectionHeaderHeight = 0
        UITableView.appearance().sectionFooterHeight = 8
    }
    var body: some View {
        NavigationView {
            VStack {
                if vm.budgets.isEmpty {
                    Spacer()
                    Text("No Budget")
                        .font(.title)
                    Spacer()
                } else {
                    List {
                        Section {
                            Picker(selection: $vm.selected, label: Text("Picker")) {
                                Text("All").tag(1)
                                Text("Spends").tag(2)
                                Text("Income").tag(3)
                            }
                            .pickerStyle(.segmented)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        
                        Section {
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
                    .listStyle(.insetGrouped)
                    .padding(.top, -25)
                }
                Button("Add new") {
                    showAdd.toggle()
                }
                .buttonStyle(BudgetButtonStyle())
                .padding(.bottom)
                .sheet(isPresented: $showAdd) {
                    CreateNewView()
                }
            }
            .background(Color.clear)
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
