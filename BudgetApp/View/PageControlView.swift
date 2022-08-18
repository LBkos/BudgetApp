//
//  PageControlView.swift
//  BudgetApp
//
//  Created by Константин Лопаткин on 18.08.2022.
//

import SwiftUI

struct PageControlView: View {
    @EnvironmentObject var vm: BudgetViewModel
    var body: some View {
        HStack(spacing: 10) {
            ForEach(1..<4, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.gray.opacity(index == vm.selected ? 1 : 0.5))
                    .onTapGesture {
                        vm.selected = index
                    }
            }
        }
    }
}

struct PageControlView_Previews: PreviewProvider {
    static var previews: some View {
        PageControlView()
    }
}
