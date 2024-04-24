//
//  CardCellView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 21.03.2024.
//

import SwiftUI

struct CardCellView: View {
    var card: Card
    
    var body: some View {
        HStack(spacing: 12) {
            if let first = card.name.first {
                Text(String(first))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(card.theme.accentColor)
                    .padding(10)
                    .background(card.theme.mainColor)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading) {
                Text(card.sum, format: .currency(code: card.currency))
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(card.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary.opacity(0.6))
            }   
        }
    }
}

#Preview {
    CardCellView(card: Card(name: "Card", theme: .orange, currency: "RUB", transactions: []))
        .modelContainer(DataController.previewContainer)
}
