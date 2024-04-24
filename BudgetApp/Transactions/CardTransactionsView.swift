//
//  CardTransactionsView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 28.03.2024.
//

import SwiftUI
import SwiftData

struct CardTransactionsView: View {
    @Query(sort: \CardTransaction.amount) var transactions: [CardTransaction]
    @Environment(AppState.self) private var appState
    var cards: [Card]
    @State var scrolledID: UUID?
    @State var title: String = ""
    var body: some View {
        @Bindable var appState = appState
        ZStack(alignment: .topTrailing) {
            backgroundView
            
            List {
                Section {
                    HorizontalCardsView(
                        cards: cards,
                        scrolledID: scrolledID
                    )
                    .onAppear {
                        title = ""
                    }
                    .onDisappear {
                        if let sum = appState.selectedCard?.sum, sum != 0 {
                            title = sum.formatted(.currency(code: appState.selectedCard?.currency ?? ""))
                        } else {
                            title = appState.selectedCard?.name ?? ""
                        }
                    }
                }
                
                Section {
                    TransactionsList(transactions: appState.selectedCard?.transactions ?? [])
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
                        .foregroundStyle(appState.selectedCard?.theme.mainColor ?? .accentColor)
                        .blendMode(.multiply)
                }
            }
        }
        .navigationTitle(title)
    }
    
    var backgroundView: some View {
        RadialGradient(
            gradient: .init(
                colors: [
                    appState.selectedCard?.theme.mainColor ?? .accentColor,
                    Color(
                        .systemGroupedBackground
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
    let card: Card = .init(name: "Tinkoff", theme: .yellow, currency: "USD", transactions: [], sum: 2000, spend: 10)
    return NavigationStack {
        CardTransactionsView(
            cards: [.init(name: "tinkoff", currency: "RUB", sum: 200), .init(name: "VTB")],
            scrolledID: card.id
        )
        .modelContainer(DataController.previewContainerTransaction)
        .environment(AppState())
        
    }
    
}
