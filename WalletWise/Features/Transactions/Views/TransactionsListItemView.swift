//
//  TransactionListItemView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct TransactionsListItemView: View {
    @Binding var transaction: Transaction
    let refreshTrigger: () async -> Void
    let onEditDismiss: () -> Void
    @StateObject private var viewModel = TransactionsViewViewModel()
    @State private var editingTransaction = Transaction(id: "", periodId: "", planningId: "", userId: "")
   
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(alignment: .bottom) {
                    Text(transaction.category.description)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    .padding(.leading, 1)
                    if transaction.isPaid {
                        Label("", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(Color.green)
                    }
                    if !transaction.isPaid {
                        Label("", systemImage: "exclamationmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                }
                    
            }
           
            Spacer()
            Text(viewModel.formatCurrency(amount: transaction.amount))
        }
        .transition(.move(edge: .leading))
//        .padding(.vertical, 2)
        .swipeActions(edge: .leading) {
            
            if !transaction.isPaid {
                Button {
                    Task {
                        await viewModel.payTransaction(transaction:transaction)
                        await refreshTrigger()
                    }
                } label: {
                    Label("Flag", systemImage: "checkmark.circle.fill")
                }
                .tint(.green)
            }
            
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                Task {
                    await viewModel.removeTransaction(periodId: transaction.periodId ?? "", transactionId: transaction.id ?? "")
                    await refreshTrigger()
                }
               
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button {
                editingTransaction = transaction
                viewModel.isPresentingEditTransactionView = true
            } label: {
                Label("Flag", systemImage: "pencil.circle")
            }
            .tint(.blue)
        }
        .sheet(isPresented: $viewModel.isPresentingEditTransactionView, onDismiss: onEditDismiss){
            
            NavigationStack {
                EditTransactionView(transaction: $editingTransaction, editTransactionPresented: $viewModel.isPresentingEditTransactionView)
//                    .toolbar {
//                        ToolbarItem(placement: .cancellationAction) {
//                            Button("Cancel") {
//                                viewModel.isPresentingEditTransactionView = false
//                            }
//                        }
//                    }
            }
            
        }
    }
    
    
}

#Preview {
    TransactionsListItemView(transaction: .constant(Transaction(id: "", periodId: "", planningId: "", userId: "", description: "Transaction description", category: Category(id: "", description: "Shopping", icon: "dollarsign.circle.fill", userId: "sdfsfwe", active: true), isPaid: false)), refreshTrigger: {
        
    }, onEditDismiss: {})
}
