//
//  DuplicateTransactionsView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 25/07/24.
//

import SwiftUI

struct DuplicateTransactionsView: View {
    @EnvironmentObject var viewModel: TransactionsViewViewModel
    @State var transactions: [Transaction]
    @Binding var duplicateTransactionPresented: Bool
    var body: some View {
        Text("Duplicate transactions")
            .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
            .bold()
            .padding(.top)
        VStack {
            List ($transactions) { transaction in
                DuplicateTransactionListItemView(transaction: transaction)
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            WWButton(isLoading: $viewModel.isLoading, label: "Submit", background: .accentColor) {
                Task {
                    await viewModel.duplicateTransactions(transactions: transactions)
                    if viewModel.formErrors.isEmpty {
                        withAnimation {
                            viewModel.selectedTransactions.removeAll()
                            viewModel.isSelectionMode = false
                            duplicateTransactionPresented = false
                        }
                    }
                }
            }
            .padding()
            .disabled(viewModel.isLoading)
        }
    }
}

#Preview {
    DuplicateTransactionsView(transactions: [Transaction(id: "sdfds2", periodId: "sdfsd", categoryId: "sfsd", planningId: "sdfsd", userId: "sfd", amount: 100, description: "Grocery store", category: Category(id: "", description: "Shopping", icon: "dollarsign.circle.fill", userId: "sdfsfwe", active: true, type: TransactionType.expense), date: Date.now, isPaid: true),], duplicateTransactionPresented: .constant(true))
        .environmentObject(PlanningStore())
        .environmentObject(TransactionsViewViewModel())
}
