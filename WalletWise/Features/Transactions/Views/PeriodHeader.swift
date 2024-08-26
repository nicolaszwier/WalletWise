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
            if (viewModel.isCurrentPeriod(periodStart: period.periodStart, periodEnd: period.periodEnd)) {
                Text("Current period")
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(Color.customAccent)
                    .cornerRadius(6)
                    .bold()
            }
        }
    }
}

#Preview {
    PeriodHeader(period: Period(id: "", planningId: "", userId: "", periodBalance: 100, periodBalancePaidOnly: 100, expectedAllTimeBalance: 120, expectedAllTimeBalancePaidOnly: 120, periodStart: Date.now, periodEnd: Date.now, transactions: []))
}
