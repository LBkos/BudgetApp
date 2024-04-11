//
//  DataController.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 21.03.2024.
//

import Foundation
import SwiftData

@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Card.self, configurations: config)
//            let containerCategory = try ModelContainer(for: CardCategory.self, configurations: config)
//            let containerTransactions = try ModelContainer(for: CardTransaction.self, configurations: config)
            for i in 1...9 {
                let card = Card(
                    name: "Card \(i)",
                    theme: .yellow,
                    currency: "RUB",
                    transactions: []
                )
//                let category = CardCategory(name: "Category \(i)", image: "house.fill", theme: .orange)
//                let transaction = CardTransaction(amount: Double((3...300).randomElement() ?? 2), comment: "", date: .now, category: category, card: card)
//                containerCategory.mainContext.insert(category)
//                containerTransactions.mainContext.insert(transaction)
                container.mainContext.insert(card)
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
    
    static let previewContainerTransaction: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
//            let container = try ModelContainer(for: Card.self, configurations: config)
//            let containerCategory = try ModelContainer(for: CardCategory.self, configurations: config)
            let containerTransactions = try ModelContainer(for: CardTransaction.self, configurations: config)
            for i in 1...9 {
                let card = Card(
                    name: "Card \(i)",
                    theme: .indigo,
                    currency: "RUB",
                    transactions: []
                )
                let category = CardCategory(name: "Category \(i)", image: "house.fill", theme: .orange)
                let transaction = CardTransaction(amount: Double((3...300).randomElement() ?? 2), comment: "", date: .now, category: category, card: card)
//                containerCategory.mainContext.insert(category)
                containerTransactions.mainContext.insert(transaction)
//                container.mainContext.insert(card)
            }

            return containerTransactions
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
