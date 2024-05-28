//
//  PeriodFooter.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 09/05/24.
//

import SwiftUI

struct PeriodFooter: View {
    @StateObject private var viewModel = TransactionsViewViewModel()
    @Binding var period: Period
    var body: some View {
        HStack {
            Text("Expected balance on \(viewModel.formattedDate(date: period.periodEnd))")
                .accessibilityLabel("Expected balance on \(period.periodEnd)")
                .foregroundColor(.secondary)
                .font(.footnote)
//                                .padding(.leading)
            Spacer()
            Text(viewModel.formatCurrency(amount: period.expectedAllTimeBalance))
                .contentTransition(.numericText())
                .transaction { t in
                    t.animation = .default
                }
                .accessibilityLabel("Period balance: \(viewModel.formatCurrency(amount: period.periodBalance))")
                .font(.title3)
                .bold()
                .foregroundColor(Color.green)
        }
    }
}

#Preview {
    PeriodFooter(period: .constant(Period(id: "", planningId: "", userId: "", periodBalance: 100, periodBalancePaidOnly: 80, expectedAllTimeBalance: 120, expectedAllTimeBalancePaidOnly: 120, periodStart: Date.now, periodEnd: Date.now, transactions: [])))
}
