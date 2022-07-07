//
//  CreateNewView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 05.07.2022.
//

import SwiftUI

struct CreateNewView: View {
    enum FocusField {
        case newSum
    }
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: BudgetViewModel
    @FocusState private var focus: FocusField?
    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .trailing) {
                ZStack {
                    TextField("0.0 ₽", text: $vm.newSum)
                        .foregroundColor(.clear)
                        .keyboardType(.decimalPad)
                        
                        .multilineTextAlignment(.center)
                        .focused($focus, equals: .newSum)
                        .frame(height: 44)
                        .background(Color.white)
                        .cornerRadius(8)
                    Text(vm.newSum)
                }
                        
                        
                        

//                        .background(Color.white)
                Button {
                    vm.newSum.removeAll()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }
            .padding(.horizontal)
            Spacer()
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
            }
            .buttonStyle(BudgetButtonStyle())
            .padding(.bottom, 16)
        }
        .background(Color.gray.opacity(0.2))
        .onAppear {
            focus = .newSum
        }
        .navigationTitle("Enter amount")
    }
}

struct CreateNewView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewView().environmentObject(BudgetViewModel())
    }
}
