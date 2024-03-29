//
//  CreateNewView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 05.07.2022.
//

import SwiftUI

struct CreateNewView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: BudgetViewModel
    init() {
        UITableView.appearance().sectionHeaderHeight = 8
        UITableView.appearance().sectionFooterHeight = 8
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        ZStack(alignment: .trailing) {
                            ZStack {
                                TextField("0.0 ₽", text: $vm.newSum)
                                    .foregroundColor(.clear)
                                    .keyboardType(.decimalPad)
                                    
                                    .multilineTextAlignment(.center)
                                    .frame(height: 44)
                                    .background(colorScheme == .dark ? Color.black : .white)
                                    .cornerRadius(8)
                                Text(vm.newSum)
                            }
                            if !vm.newSum.isEmpty {
                                Button {
                                    vm.newSum.removeAll()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal)
                    }
                    Section {
                        TextField("Payment name", text: $vm.name)
                        DatePicker("Date", selection: $vm.createAt)
                            .datePickerStyle(.compact)
                            
                    }
                }
                .buttonStyle(.borderless)
                .listStyle(.insetGrouped)
                Picker("", selection: $vm.selectType) {
                    Text("Spend").tag(1)
                    Text("Income").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 16)
                .padding(.horizontal)
                Button {
                    vm.addNew()
                    dismiss()
                } label: {
                    Text("Add new")
                        .foregroundColor(vm.newSum.isEmpty ? .gray : .white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            vm.newSum.isEmpty ? Color.gray.opacity(0.2) : .blue
                        )
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .disabled(vm.newSum.isEmpty)
                .padding(.bottom, 16)
            }
            .background(Color(UIColor.systemGray6))
        .navigationTitle("Enter amount")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        }
        }
    }
}

struct CreateNewView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewView().environmentObject(BudgetViewModel())
    }
}
