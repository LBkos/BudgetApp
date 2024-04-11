//
//  TransactionViewModel.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 28.03.2024.
//

import SwiftUI
import SwiftData

@Observable
class TransactionViewModel {
    var type: TransactionType = .spend
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
            
            if type == .spend {
                transaction.card?.sum -= transaction.amount
                transaction.card?.spend += transaction.amount
            } else {
                transaction.card?.sum += transaction.amount
            }
            
            context.insert(transaction)
            transaction.card?.transactions.append(transaction)
            dismiss()
        } else {
            print("Error")
        }
    }
}

enum TransactionType: String {
    case spend = "Spend"
    case income = "Add"
}
