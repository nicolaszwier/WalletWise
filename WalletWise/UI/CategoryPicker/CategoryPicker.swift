//
//  CategoryPicker.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 27/05/24.
//

import SwiftUI

struct CategoryPicker: View {
    @EnvironmentObject var viewModel: AppViewViewModel
    @Binding var selection: Category
    
    var body: some View {
        Picker("Category", selection: $selection) {
            ForEach(viewModel.user.categories ?? []) { category in
                CategoryPickerItemView(category: category)
                    .tag(category)
            }
        }
        .pickerStyle(.navigationLink)
    }
}

#Preview {
    CategoryPicker(selection: .constant(Category(id: "", description: "Shopping", icon: "dollarsign.circle.fill", userId: "sdfsfwe", active: true)))
        .environmentObject(AppViewViewModel())
}
