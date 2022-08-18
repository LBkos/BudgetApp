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
                        ForEach(vm.filterDateBudget()) { element in
                            Section(vm.createTitle(element.title)) {
                                inSection(budgets: element.budgetList)
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                    
                    
                    //                    .padding(.top, -25)
                }
                PageControlView()
                    .padding(.bottom)
                Button("Add new") {
                    showAdd.toggle()
                }
                .buttonStyle(BudgetButtonStyle())
                .padding(.bottom)
                .sheet(isPresented: $showAdd) {
                    CreateNewView()
                }
            }
            .onTapGesture{}
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded({ value in
                                    if value.translation.width < 0 {
                                        // left
                                        if vm.selected < 3 {
                                            vm.selected += 1
                                        } else {
                                            vm.selected = 1
                                        }
                                    }

                                    if value.translation.width > 0 {
                                        // right
                                        if vm.selected > 1 {
                                            vm.selected -= 1
                                        } else {
                                            vm.selected = 3
                                        }
                                    }
                                    if value.translation.height < 0 {
                                        // up
                                    }

                                    if value.translation.height > 0 {
                                        // down
                                    }
                                }))
            .navigationTitle(Text(vm.allSum()))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(vm.subTitle())
                }
            }
            .background(Color.background)
        }
        .navigationViewStyle(.stack)
    }
    
    func inSection(budgets: [Budget]) -> some View {
        ForEach(budgets) { item in
            HStack {
                Image(systemName: item.type == "income" ? "plus.circle.fill" : "minus.circle.fill")
                    .foregroundColor(item.type == "income" ? .green : .orange)
                Text(vm.formatter.string(from: NSNumber(value: Double(item.sum ?? "") ?? 0.0)) ?? "")
                     Spacer()
                Text(item.name ?? "")
                    .foregroundColor(.gray.opacity(0.7))
            }
        }
        .onDelete { indexSet in
            vm.delete(indexSet: indexSet, array: budgets)
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
