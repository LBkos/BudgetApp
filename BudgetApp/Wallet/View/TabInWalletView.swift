//
//  TabInWalletView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 21.03.2024.
//

import SwiftUI

struct TabInWalletView: View {
    @State var vm: TabWalletViewModel
    var type: TabWalletType = .balance
    @State var selection: Int = 0
    init(
        cards: [Card],
        type: TabWalletType
    ) {
        self.vm = TabWalletViewModel(cards: cards)
        self.type = type
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(vm.currences.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.currences[index].sum, format: .currency(code: vm.currences[index].currency))
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(type.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(.secondary.opacity(0.6))
                }
                .id(index)
            }
        }
        .frame(minHeight: 67)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(.rect(cornerRadius: 10))
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onTapGesture {
            if selection < vm.currences.count {
                selection += 1
            } else {
                selection = 0
            }
        }
        .onAppear {
            if type == .balance {
                vm.cardSum()
            } else {
                vm.cardSpend()
            }
            
        }
    }
}

#Preview {
    TabInWalletView(cards: [], type: .balance)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary.opacity(0.2))
        .modelContainer(DataController.previewContainer)
}

