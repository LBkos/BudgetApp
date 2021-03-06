//
//  ViewModel.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 05.07.2022.
//

import Foundation
import CoreData
import Combine

class BudgetViewModel: ObservableObject {
        
    @Published var budgets: [Budget] = []
    @Published var selected: Int = 1
    @Published var newSum = "" 
    @Published var selectType: Int = 1
    var persistence = PersistenceController.shared
    private var store: Set<AnyCancellable> = []
    
    let formatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
//        formatter.currencyDecimalSeparator = "/"
        formatter.currencySymbol = Locale.current.currencySymbol ?? "₽"
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        return formatter
    }()
    
    func removeLast(value: String, index: String.Index) -> String {
        if value.distance(from: index, to: value.endIndex) > 3 {
            return String(value.dropLast())
        } else {
            return value
        }
    }
    
    var textInTextFieldPublisher: AnyPublisher<String, Never> {
        $newSum
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { value in
                var sum = value
                if let index = value.lastIndex(of: ",") {
                    sum = self.removeLast(value: value, index: index)
                    
                } else if let index = value.lastIndex(of: ".") {
                    sum = self.removeLast(value: value, index: index)
                }
                let filteredValue = sum.filter { "1234567890.,".contains($0) }
                
                if sum != filteredValue {
                    sum = filteredValue
                }
                return sum
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        fetchData()
        textInTextFieldPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.newSum, on: self)
            .store(in: &store)
    }
    
    func fetchData() {
        let request = NSFetchRequest<Budget>(entityName: "Budget")
        do {
            budgets = try persistence.container.viewContext.fetch(request)
        } catch let error {
            print(error)
        }
    }
    
    func allSum() -> String {
        var sum = 0.0
        for budget in filteredBudget() {
            if budget.type == "income" {
                sum += Double(budget.sum ?? "") ?? 0
            } else {
                sum -= Double(budget.sum ?? "") ?? 0
            }
        }
        return formatter.string(from: NSNumber(value: sum)) ?? "Budget"
    }
    
    func addNew() {
        let newBudget = Budget(context: persistence.container.viewContext)
        newBudget.id = UUID()
        newBudget.sum = newSum.replacingOccurrences(of: ",", with: ".")
        newBudget.type = selectType == 1 ? "spend" : "income"
        persistence.save()
        newSum.removeAll()
        fetchData()
    }
    
    func filteredBudget() -> [Budget] {
        switch selected {
        case 1:
            return budgets
        case 2:
            return budgets.filter { $0.type == "spend" }
        case 3:
            return budgets.filter { $0.type == "income" }
        default:
            return budgets
        }
    }
    
    func delete(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = budgets[index]
        persistence.container.viewContext.delete(entity)
        saveData()
    }
 
    func saveData() {
        do {
            try persistence.container.viewContext.save()
            fetchData()
        } catch let error {
            print(error)
        }
    }
}
