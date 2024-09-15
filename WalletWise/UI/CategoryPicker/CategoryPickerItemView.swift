//
//  CategoryPickerItemView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 23/05/24.
//

import SwiftUI

struct CategoryPickerItemView: View {
    let category: Category
    
    var body: some View {
        HStack(alignment: .center, spacing: 14.0) {
            IconRoundedRectangleView(icon: category.icon ?? "ellipsis.circle.fill", circleColor: Color(UIColor.secondarySystemFill), imageColor: .primary, frameSize: 16)
            
            Text(NSLocalizedString(category.description, comment: ""))
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CategoryPickerItemView(category: Category(id: "", description: "Shopping", icon: "dollarsign.circle.fill", userId: "sdfsfwe", active: true, type: TransactionType.expense))
}
