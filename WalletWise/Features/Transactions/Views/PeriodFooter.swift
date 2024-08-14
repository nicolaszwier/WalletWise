//
//  PeriodFooter.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 09/05/24.
//

import SwiftUI

struct PeriodFooter: View {
    @StateObject private var viewModel = TransactionsViewViewModel()
    @EnvironmentObject var planningStore: PlanningStore
    @Binding var period: Period
    var body: some View {
        HStack {
            Text("Expected balance on \(viewModel.formattedDate(date: period.periodEnd))")
                .accessibilityLabel("Expected balance on \(period.periodEnd)")
                .foregroundColor(.secondary)
                .font(.footnote)
//                                .padding(.leading)
            Spacer()
            Text(period.expectedAllTimeBalance.formatted(.currency(code: planningStore.planning?.currency.rawValue ?? "BRL")))
                .contentTransition(.numericText())
                .transaction { t in
                    t.animation = .default
                }
                .font(.title3)
                .bold()
                .foregroundColor(Color.secondary)
        }
    }
}

#Preview {
    PeriodFooter(period: .constant(Period(id: "", planningId: "", userId: "", periodBalance: 100, periodBalancePaidOnly: 80, expectedAllTimeBalance: 120, expectedAllTimeBalancePaidOnly: 120, periodStart: Date.now, periodEnd: Date.now, transactions: [])))
        .environmentObject(PlanningStore())
}
