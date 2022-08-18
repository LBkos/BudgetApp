//
//  ViewModel.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 05.07.2022.
//

import Foundation
import CoreData
import Combine
import SwiftUI

class BudgetViewModel: ObservableObject {
    
    static let dateFormat: DateFormatter = {
       let format = DateFormatter()
        format.dateFormat = "dd MMMM YYYY"
        return format
    }()
    static let shared = BudgetViewModel()
    @Published var budgets: [Budget] = []
    @Published var selected: Int = 1
    @Published var newSum = "" 
    @Published var selectType: Int = 1
    //new fields
    @Published var name = ""
    @Published var createAt = Date()
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
    
    func createTitle(_ title: String) -> String {
        if title == Self.dateFormat.string(from: .now) {
            return NSLocalizedString("Today", comment: "")
        } else if title == Self.dateFormat.string(from: .now - 84600) {
            return NSLocalizedString("Yesterday", comment: "")
        } else {
            return title
        }
    }
    
    func filterDateBudget() -> [FileredDate] {
        var filteredDate: [FileredDate] = []
        for budget in filteredBudget() {
            let title = Self.dateFormat.string(from: budget.createAt ?? Date())
            let element = FileredDate(title: title,
                                      budgetList: filteredBudget().filter({ Self.dateFormat.string(from: ($0.createAt ?? Date())) == title }))
            if !filteredDate.contains(where: {$0.title == title }) {
                filteredDate.append(element)
            }
        }
        filteredDate = filteredDate.sorted { $0.title > $1.title }
        return filteredDate
    }
    
    func subTitle() -> String {
        switch selected {
        case 1:
            return NSLocalizedString("All", comment: "")
        case 2:
            return NSLocalizedString("Expense", comment: "")
        case 3:
            return NSLocalizedString("Income", comment: "")
        default:
            return NSLocalizedString("All", comment: "")
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
        newBudget.name = name
        newBudget.createAt = createAt
        newBudget.sum = newSum.replacingOccurrences(of: ",", with: ".")
        newBudget.type = selectType == 1 ? "spend" : "income"
        persistence.save()
        newSum.removeAll()
        fetchData()
    }
    
    func filteredBudget() -> [Budget] {
        switch selected {
        case 1:
            return budgets.reversed()
        case 2:
            return budgets.filter { $0.type == "spend" }.reversed()
        case 3:
            return budgets.filter { $0.type == "income" }.reversed()
        default:
            return budgets.reversed()
        }
    }
    
    func delete(indexSet: IndexSet, array: [Budget]) {
        guard let index = indexSet.first else { return }
        let entity = array[index]
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


extension Color {
    static let background = Color("background")
}

struct FileredDate: Identifiable, Hashable {
    let id = UUID().uuidString
    let title: String
    let budgetList: [Budget]
}
