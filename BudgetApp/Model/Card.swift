//
//  WalletModel.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 21.03.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Card {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var theme: Theme
    var currency: String
    var transactions: [Transaction]
    var sum: String {
        let formatter = Formatters.currencyFormatter
        formatter.currencyCode = currency
        var sum = 0.0
        for transaction in transactions {
            sum += transaction.amount
        }
        return formatter.string(from: NSNumber(value: sum)) ?? "0"
    }
    
    init(name: String, theme: Theme, currency: String, transactions: [Transaction]) {
        self.name = name
        self.theme = theme
        self.currency = currency
        self.transactions = transactions
    }
}


@Model
class Transaction {
    var amount: Double
    var comment: String
    var date: Date
    var category: Category
    var card: Card

    init(amount: Double, comment: String, date: Date, category: Category, card: Card) {
        self.amount = amount
        self.comment = comment
        self.date = date
        self.category = category
        self.card = card
    }
}

@Model
class Category {
    var name: String
    var image: String
    var theme: Theme
    
    init(name: String, image: String, theme: Theme) {
        self.name = name
        self.image = image
        self.theme = theme
    }
}
