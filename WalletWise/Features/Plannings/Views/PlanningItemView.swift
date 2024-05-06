//
//  PlanningItemView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import SwiftUI

struct PlanningItemView: View {
    let planning: Planning
    
    var body: some View {
        VStack {
            Image(systemName: "dollarsign.circle.fill")
                .padding()
            Text(planning.description)
                .padding([.leading, .bottom, .trailing])
                .fontWeight(.heavy)
        }
        .background(.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        
    }
}

#Preview {
    PlanningItemView(planning: Planning(id: "123a", description: "Sample planning", currency: Currency.cad, initialBalance: 100, dateOfCreation: Date.now))
}
