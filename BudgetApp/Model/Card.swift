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
    @Relationship(deleteRule: .cascade, inverse: \CardTransaction.card)
    var transactions: [CardTransaction]
    var sum: Double
    var spend: Double
    
    init(name: String = "", theme: Theme = .bubblegum, currency: String = "", transactions: [CardTransaction] = [], sum: Double = 0, spend: Double = 0) {
        self.name = name
        self.theme = theme
        self.currency = currency
        self.transactions = transactions
        self.sum = sum
        self.spend = spend
    }
}


@Model
class CardTransaction {
    var amount: Double
    var comment: String
    var date: Date
    var category: CardCategory
    var card: Card?

    init(amount: Double = 0.0, comment: String = "", date: Date = .now, category: CardCategory = .init(), card: Card? = .init()) {
        self.amount = amount
        self.comment = comment
        self.date = date
        self.category = category
        self.card = card
    }
}

@Model
class CardCategory {
    var name: String
    var image: String
    var theme: Theme
    
    init(name: String = "", image: String = "", theme: Theme = .indigo) {
        self.name = name
        self.image = image
        self.theme = theme
    }
}
