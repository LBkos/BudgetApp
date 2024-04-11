//
//  CurrencyTabWallet.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 10.04.2024.
//

import Foundation

struct CurrencyTabWallet: Identifiable {
    let id: UUID = UUID()
    var currency: String
    var sum: Double
}
