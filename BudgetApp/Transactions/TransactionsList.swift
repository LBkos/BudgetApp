//
//  TransactionsList.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 09.04.2024.
//

import SwiftUI
import SwiftData
struct TransactionsList: View {
    var transactions: [CardTransaction]
    var body: some View {
        ForEach(transactions) { transaction in
            HStack(spacing: 12) {
                categoryImage(transaction)
                
                VStack(alignment: .leading) {
                    Text(transaction.comment)
                        .fontWeight(.semibold)
                    
                    Text(transaction.category.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing) {
                    
                    if transaction.type == .income {
                        Group {
                            Text("+") + amount(transaction)
                        }
                        .foregroundStyle(.green)
                    } else {
                        Text("-") + amount(transaction)
                    }
                    
                    Text(transaction.card?.name ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            
        }
    }
    
    func categoryImage(_ transaction: CardTransaction) -> some View {
        Image(systemName: transaction.category.image)
            .foregroundStyle(transaction.category.theme.accentColor)
            .frame(width: 44, height: 44)
            .background(transaction.category.theme.mainColor)
            .clipShape(.circle)
    }
    
    func amount(_ transaction: CardTransaction) -> Text {
        Text(transaction.amount, format: .currency(code: transaction.card?.currency ?? ""))
    }
}

#Preview {
    List {
        TransactionsList(transactions: .init())
    }
        .modelContainer(DataController.previewContainerTransaction)
}
