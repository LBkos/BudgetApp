//
//  TransactionsList.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 09.04.2024.
//

import SwiftUI

struct TransactionsList: View {
    var transactions: [CardTransaction]
    var body: some View {
        ForEach(transactions) { transaction in
            Text("\(transaction.amount)")
        }
    }
}

#Preview {
    TransactionsList(transactions: .init())
}
