//
//  CreateTransactionView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 25.03.2024.
//

import SwiftUI
import SwiftData

struct CreateTransactionView: View {
    //    @Query(sort: \CardCategory.name) var categories: [CardCategory]
    @Query(sort: \Card.name) var cards: [Card]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State var vm = TransactionViewModel()
    
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField(
                        "\(vm.type.rawValue) amount",
                        text: $vm.amount
                    )
                }
                
                Section {
                    TextField("Transactions description", text: $vm.comment)
                    DatePicker("Date", selection: $vm.date)
                }
                
                Section {
                    Menu {
                        ForEach(categories) { category in
                            Button {
                                cardTransaction.category = category
                            } label: {
                                Label(category.name, systemImage: category.image)
                            }
                        }
                        Section {
                            Button {
                                isPresented.toggle()
                            } label: {
                                Text("Add Category")
                            }
                        }
                        
                    } label: {
                        menuLabel(
                            title: "Category",
                            name: "Home",
                            image: "house.fill"
                        )
                    }
                }
                
                Section {
                    Menu {
                        ForEach(cards) { card in
                            Button {
                                vm.card = card
                            } label: {
                                Text(card.name)
                                Circle()
                                    .fill(card.theme.mainColor)
                            }
                            
                        }
                    } label: {
                        menuLabel(
                            title: "Card",
                            name: vm.card?.name ?? "",
                            circleColor: vm.card?.theme.mainColor ?? .blue
                        )
                    }
                }
                .onAppear {
                    self.vm.card = cards.first
                }
            }
            .navigationTitle(vm.type.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        vm.addTransaction(context: context, dismiss: dismiss)
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    @ViewBuilder
    func menuLabel(
        title: String,
        name: String,
        image: String? = nil,
        circleColor: Color = .primary
    ) -> some View {
        HStack(spacing: 9) {
            if let image = image {
                Image(systemName: image)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.gray)
                    .clipShape(Circle())
            }
            Text(title)
                .foregroundStyle(Color.primary)
            
            Spacer()
            
            Circle()
                .fill(circleColor)
                .frame(width: 15)
            Text(name)
                .foregroundStyle(Color.secondary)
            Image(systemName: "chevron.up.chevron.down")
                .font(.callout)
                .foregroundStyle(Color.secondary)
        }
    }
    
    init(type: TransactionType = .spend) {
        self.vm.type = type
    }
}

#Preview {
    CreateTransactionView()
        .modelContainer(DataController.previewContainer)
}

