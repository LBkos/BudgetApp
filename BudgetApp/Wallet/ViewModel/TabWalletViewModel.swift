//
//  TabViewModel.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 10.04.2024.
//

import Foundation
import SwiftUI

@Observable
class TabWalletViewModel {
    var cards: [Card]
    var currences: [CurrencyTabWallet] = []
    var spend: [CurrencyTabWallet] = []
    
    init(cards: [Card]) {
        self.cards = cards
    }
    
    func cardSum() {
        cards.forEach { card in
            if !currences.contains(where: {$0.currency == card.currency}) {
                currences.append(.init(currency: card.currency, sum: card.sum))
            } else {
                if let index = currences.firstIndex(where: {$0.currency == card.currency}) {
                    currences[index].sum += card.sum
                }
            }
        }
    }
    func cardSpend() {
        cards.forEach { card in
            if !spend.contains(where: {$0.currency == card.currency}) {
                spend.append(.init(currency: card.currency, sum: card.spend))
            } else {
                if let index = spend.firstIndex(where: {$0.currency == card.currency}) {
                    spend[index].sum += card.spend
                }
            }
        }
    }
}
