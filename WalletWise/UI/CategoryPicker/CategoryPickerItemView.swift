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
        HStack(alignment: .center, spacing: 12.0) {
            IconCircleView(icon: "dollarsign.circle.fill", circleColor: Color.pink, imageColor: .white, frameSize: 12)
            
            Text(category.description)
                .font(.headline)
        }
    }
}

#Preview {
    CategoryPickerItemView(category: Category(id: "", description: "Shopping", icon: "dollarsign.circle.fill", userId: "sdfsfwe", active: true))
}
