//
//  CardItemView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 09.04.2024.
//

import SwiftUI

struct CardItemView: View {
    var card: Card
    init(_ card: Card) {
        self.card = card
    }
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(card.theme.mainColor)
            .overlay(alignment: .bottomLeading) {
                Text(card.name)
                    .foregroundStyle(card.theme.accentColor)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.leading, .bottom])
            }
            .overlay(alignment: .topLeading, content: {
                Text(card.sum, format: .currency(code: card.currency))
                    .font(.title)
                    .foregroundStyle(card.theme.accentColor)
                    .fontWeight(.bold)
                    .padding([.top, .leading])
            })
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .fill(.white)
            }
            .frame(height: 240)
            .containerRelativeFrame(.horizontal)
    }
}

#Preview {
    CardItemView(.init())
}
