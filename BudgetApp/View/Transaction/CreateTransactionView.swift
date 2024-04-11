//
//  CreateTransactionView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 25.03.2024.
//

import SwiftUI
import SwiftData

@Observable
class TransactionViewModel {
    var amount = ""
    var comment = ""
    var date: Date = .now
    var card: Card? = nil
    var transaction: CardTransaction? = nil
    
    func addTransaction(context: ModelContext, dismiss: DismissAction) {
        transaction = .init(
            amount: Double(amount) ?? 0,
            comment: comment,
            date: date,
            category: .init(),
            card: card
        )
        if let transaction = transaction {
            transaction.card?.sum += transaction.amount
            context.insert(transaction)
            transaction.card?.transactions.append(transaction)
            dismiss()
        } else {
            print("Error")
        }
    }
}

struct CreateTransactionView: View {
    //    @Query(sort: \CardCategory.name) var categories: [CardCategory]
    @Query(sort: \Card.name) var cards: [Card]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State var vm = TransactionViewModel()
    var type: TransactionType
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField(
                        "\(type.rawValue) amount",
                        text: $vm.amount
                    )
                }
                
                Section {
                    TextField("Transactions description", text: $vm.comment)
                    DatePicker("Date", selection: $vm.date)
                }
                
                Section {
                    Menu {
                        
                    } label: {
                        menuLabel(
                            title: "Category",
                            name: "Home",
                            image: "house.fill"
                        )
                    }
                }
                
                Section {
                    Menu {
                        ForEach(cards) { card in
                            Button {
                                vm.card = card
                            } label: {
                                Text(card.name)
                            }
                            
                        }
                    } label: {
                        menuLabel(
                            title: "Card",
                            name: vm.card?.name ?? ""
                        )
                    }
                }
            }
            .navigationTitle(type.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        vm.addTransaction(context: context, dismiss: dismiss)
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    @ViewBuilder
    func menuLabel(
        title: String,
        name: String,
        image: String? = nil
    ) -> some View {
        HStack(spacing: 9) {
            if let image = image {
                Image(systemName: image)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.gray)
                    .clipShape(Circle())
            }
            Text(title)
                .foregroundStyle(Color.primary)
            
            Spacer()
            
            Circle()
                .frame(width: 15)
            Text(name)
                .foregroundStyle(Color.secondary)
            Image(systemName: "chevron.up.chevron.down")
                .font(.callout)
                .foregroundStyle(Color.secondary)
        }
    }
    
    init(type: TransactionType = .spend) {
        self.type = type
    }
}

#Preview {
    CreateTransactionView()
        .modelContainer(DataController.previewContainer)
}

enum TransactionType: String {
    case spend = "Spend"
    case add = "Add"
}
