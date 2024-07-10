//
//  CategoryPicker.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 27/05/24.
//

import SwiftUI

struct CategoryPicker: View {
    @EnvironmentObject var viewModel: AppViewViewModel
    @Binding var transactionType: TransactionType
    @Binding var selection: Category
    
    var body: some View {
        Picker("Category", selection: $selection) {
            ForEach(viewModel.user.categories?.filter({$0.type == transactionType}) ?? []) { category in
                CategoryPickerItemView(category: category)
                    .tag(category)
            }
        }
        .pickerStyle(.navigationLink)
    }
}

#Preview {
    CategoryPicker(transactionType: .constant(TransactionType.expense), selection: .constant(Category(id: "", description: "Shopping", icon: "dollarsign.circle.fill", userId: "sdfsfwe", active: true, type: TransactionType.income)))
        .environmentObject(AppViewViewModel())
}
