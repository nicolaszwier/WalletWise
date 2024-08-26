//
//  DashboardExpiringTransactionsSection.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 03/08/24.
//

import SwiftUI

struct DashboardExpiringTransactionsSection: View {
    @Binding var transactions: [Transaction]
    @EnvironmentObject var planningStore: PlanningStore
    @EnvironmentObject var viewModel: DashboardViewViewModel
    
    var body: some View {
        GroupBox(label:
                    HStack(alignment: .center) {
            Text("Pending transactions due this week").foregroundStyle(.secondary).font(.footnote)
            
        }
            .padding(.bottom)
        ) {
            
            VStack(alignment: .leading) {
                ForEach($viewModel.expiringTransactions, id: \.self) { $transaction in
                    TransactionsListItemView(transaction: $transaction, isSelected: false, toggleSelection: {}, refreshTrigger: {}, onEditDismiss: {}, allowSelection: false, allowSwipeActions: false)
                        .padding(.vertical, 6)
                }
            }
            
            if transactions.isEmpty {
                
                VStack {
                    Image(systemName: "calendar.badge.checkmark.rtl")
                        .font(.system(size: 70))
                        .foregroundColor(.secondary)
                        .padding()
                    Text("No transactions pending for this week")
                        .foregroundStyle(.secondary)
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    DashboardExpiringTransactionsSection(transactions: .constant([Transaction(id: "", periodId: "", categoryId: "", planningId: "", userId: "", description: "Walmart groceries", isPaid: false)]))
        .environmentObject(PlanningStore())
        .environmentObject(TransactionsViewViewModel())
        .environmentObject(DashboardViewViewModel())
}
