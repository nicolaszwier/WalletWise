//
//  TimelineTotalsViews.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 11/05/24.
//

import SwiftUI

struct TimelineTotalsViews: View {
    let expectedBalance: Decimal
    let currentBalance: Decimal
    @StateObject private var viewModel = TransactionsViewViewModel()
    
    var body: some View {
        HStack {
            VStack {
                Text("Current balance")
                    .foregroundColor(.secondary)
                    .font(.footnote)
                Text(viewModel.formatCurrency(amount: currentBalance))
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.green)
            }
            Spacer()
            VStack {
                Text("Expected balance")
                    .foregroundColor(.secondary)
                    .font(.footnote)
                Text(viewModel.formatCurrency(amount: expectedBalance))
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.green)
            }
        }
        .padding(.horizontal, 35)
        .padding(.top)
    }
}

#Preview {
    TimelineTotalsViews(expectedBalance: 100, currentBalance: 90)
}
