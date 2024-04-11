//
//  AddCardView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 21.03.2024.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var card: Card = .init(name: "", theme: .seafoam, currency: "", transactions: [])
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(card.theme.mainColor)
                        .frame(height: 240)
                        .overlay(alignment: .bottomLeading) {
                            Text(card.name)
                                .foregroundStyle(card.theme.accentColor)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 16)
                            
                        }
                }
                .listRowInsets(EdgeInsets())
                
                Section {
                    TextField("Card Name", text: $card.name)
                }
                //color section
                Section {
                    colorSection
                }
                
                Section {
                    Menu {
                        Section {
                            ForEach(smallCodes, id: \.self) { currency in
                                Button {
                                    card.currency = currency
                                } label: {
                                    Text(currencyName(currencyCode: currency))
                                }
                            }
                        }
                        Menu {
                            ForEach(currencyCodes, id: \.self) { currency in
                                Button {
                                    card.currency = currency
                                } label: {
                                    Text(currencyName(currencyCode: currency))
                                }
                            }
                        } label: {
                            Text("More")
                        }
                        
                    } label: {
                        
                        Text ("Currency")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color(.label))
                        
                        Text(currencyName(currencyCode: card.currency))
                            .foregroundStyle(Color(.secondaryLabel))
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
                
            }
            .navigationTitle("New Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        context.insert(card)
                        dismiss()
                    } label: {
                        Text("Add")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
    
    var colorSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Theme.allCases, id: \.self) { theme in
                    Circle()
                        .fill(theme.mainColor)
                        .frame(width: 38)
                        .onTapGesture {
                            card.theme = theme
                        }
                        .overlay {
                            if card.theme == theme {
                                Circle()
                                    .stroke(.white, lineWidth: 4)
                                    .frame(width: 30, height: 30)
                            }
                        }
                }
            }
            
        }
        .listRowInsets(EdgeInsets())
        .padding()
        .scrollClipDisabled()
        
    }
}

#Preview {
    AddCardView()
        .modelContainer(DataController.previewContainer)
    
}
