//
//  HorizontalCardsView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 09.04.2024.
//

import SwiftUI

struct HorizontalCardsView: View {
    var cards: [Card]
    @Binding var card: Card
    @State var scrolledID: UUID?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(cards) { card in
                        CardItemView(card)
                            .id(card.id)
                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.8)
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollPosition(id: $scrolledID)
            .scrollClipDisabled()
            
            pageControl
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .onChange(of: scrolledID) { _, _ in
            withAnimation {
                self.card = cards.first(where: { $0.id == scrolledID }) ?? Card.init()
            }
            
        }
    }
    
    private var pageControl: some View {
        HStack {
            ForEach(cards.indices, id: \.self) { index in
                Circle()
                    .fill(cards[index].id == scrolledID ? .black : Color(.tertiaryLabel))
                    .frame(height: 8)
                    .onTapGesture {
                        withAnimation {
                            scrolledID = cards[index].id
                        }
                    }
                
            }
        }
        .padding(9)
        .background(
            Capsule()
                .fill(
                    Color(.secondarySystemFill)
                )
        )
    }
}

#Preview {
    HorizontalCardsView(cards: [], card: .constant(.init()))
}
