//
//  PeriodHeader.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 09/05/24.
//

import SwiftUI

struct PeriodHeader: View {
    @StateObject private var viewModel = TransactionsViewViewModel()
    let period: Period
    var body: some View {
        HStack {
            Text("\(viewModel.formattedDate(date: period.periodStart)) to \(viewModel.formattedDate(date: period.periodEnd))")
                .accessibilityLabel("Period start date to period end date")
                .bold()
                .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
            Spacer()
//                            Text(viewModel.formatCurrency(amount: period.periodBalance))
//                                .accessibilityLabel("Balance: \(viewModel.formatCurrency(amount: period.periodBalance))")
//                                .bold()
//                                .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
//                                .foregroundColor(.secondary)
//                                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    PeriodHeader(period: Period(id: "", planningId: "", userId: "", periodBalance: 100, periodBalancePaidOnly: 100, expectedAllTimeBalance: 120, expectedAllTimeBalancePaidOnly: 120, periodStart: Date.now, periodEnd: Date.now, transactions: []))
}
