//
//  BudgetView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 05.07.2022.
//

import SwiftUI
import SwiftData

struct WalletView: View {
    @State var appState = AppState()
    @Query(sort: \Card.name) var cards: [Card]
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @State private var isPresentedNewCard = false
    @State private var isPresentedSpend = false
    @State var path: NavigationPath = .init()
    @State private var selectCard: Card? = nil
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(cards) { card in
                        NavigationLink(value: card) {
                            CardCellView(card: card)
                        }
                    }
                    .onDelete(perform: onDelete)
                } header: {
                    Text("Cards")
                }
            }
            .listSectionSpacing(20)
            .listStyle(.insetGrouped)
            .overlay {
                if cards.isEmpty {
                    Text("No Cards")
                        .foregroundStyle(.secondary.opacity(0.6))
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Add Card") {
                        isPresentedNewCard.toggle()
                    }
                    
                    Button("Spend") {
                        isPresentedSpend.toggle()
                    }
                }
            }
            .sheet(isPresented: $isPresentedSpend) {
                CreateTransactionView(type: .spend)
                    .modelContext(context)
            }
            .sheet(isPresented: $isPresentedNewCard) {
                AddCardView()
            }
            .navigationDestination(for: Card.self) { card in
                CardTransactionsView(
                    cards: cards,
                    scrolledID: card.id
                )
                .environment(appState)
                .onAppear {
                    appState.selectedCard = card
                }
            }
            .navigationTitle(Text("Wallet"))
            .onAppear {
                appState.selectedCard = nil
            }
        }
        .tint(appState.selectedCard?.theme.mainColor)
    }
    
    private func onDelete(at offsets: IndexSet) {
        for index in offsets {
            let card = cards[index]
            context.delete(card)
        }
    }
}

#Preview {
    WalletView()
        .modelContainer(DataController.previewContainer)
}
