//
//  CardTransactionsView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 28.03.2024.
//

import SwiftUI
import SwiftData

struct CardTransactionsView: View {
    var cards: [Card]
    @State var card: Card = .init()
    @State var scrolledID: UUID?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            backgroundView
            
            List {
                Section {
                    HorizontalCardsView(
                        cards: cards,
                        card: $card,
                        scrolledID: scrolledID
                    )
                }
                
                Section {
                    TransactionsList(transactions: card.transactions)
                        .listRowBackground(
                            Color.white 
                                .opacity(0.7)
                        )
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "pencil")
                        .foregroundStyle(card.theme.mainColor)
                        .blendMode(.multiply)
                }
            }
        }
    }
    
    var backgroundView: some View {
        RadialGradient(
            gradient: .init(
                colors: [
                    card.theme.mainColor,
                    Color(
                        .systemBackground
                    )
                ]
            ),
            center: .topTrailing,
            startRadius: 5,
            endRadius: 400
        )
        .ignoresSafeArea()
    }
}

#Preview {
    let card: Card = .init(name: "Tinkoff", theme: .yellow, currency: "USD", transactions: [], sum: 2000)
    return NavigationStack {
        CardTransactionsView(
            cards: [.init(), .init()],
            card: card,
            scrolledID: card.id
        )
        .modelContainer(DataController.previewContainer)
    }
    
}
