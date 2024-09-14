//
//  TransactionsListView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct TransactionsListView: View {
    let planning: Planning
    @State var periods: [Period]
    @EnvironmentObject var viewModel: TransactionsViewViewModel
    var body: some View {
        ForEach($periods, id: \.self) { $period in
            if !period.transactions.isEmpty {
                Section {
                    ForEach(period.transactions.indices, id: \.self) { index in
                        let transaction = period.transactions[index]
                        TransactionsListItemView(transaction: $period.transactions[index], isSelected: viewModel.selectedTransactions.contains(transaction), toggleSelection: {
                            if viewModel.selectedTransactions.contains(transaction) {
                                viewModel.selectedTransactions.remove(transaction)
                            } else {
                                viewModel.selectedTransactions.insert(transaction)
                            }
                            withAnimation {
                                if !viewModel.selectedTransactions.isEmpty {
                                    viewModel.isSelectionMode = true
                                } else {
                                    viewModel.isSelectionMode = false
                                }
                            }
                        }, refreshTrigger: {
                            await viewModel.fetch(planning: planning)
                        }, onEditDismiss: didDismiss, allowSelection: true, allowSwipeActions: true)
                    }
                } header: {
                    PeriodHeader(period: period)
                } footer: {
                    PeriodFooter(period: $period)
                        .padding(.bottom)
                }
                
            }
        }
    }
    
    func didDismiss() {
        Task {
            await viewModel.fetch(planning: planning)
        }
    }
}

#Preview {
    List {
        TransactionsListView(planning: Planning(id: "6680c1ae817a7ffd7d648e27", description: "Sample planning name bem grndao", currency: Currency.cad, currentBalance: 100, expectedBalance: 100, dateOfCreation: Date.now), periods: [Period(id: "sdfds", planningId: "sfsdf", userId: "sdfds", periodBalance: 10, periodBalancePaidOnly: 10, expectedAllTimeBalance: 20, expectedAllTimeBalancePaidOnly: 20, periodStart: Date.now, periodEnd: Date.now, transactions: [Transaction(id: "sdfds", periodId: "adsad", categoryId: "asdad", planningId: "asdas", userId: "asdas", amount: 10, description: "test")])])
            .environmentObject(AppViewViewModel())
            .environmentObject(PlanningStore())
            .environmentObject(TransactionsViewViewModel())
    }
}
