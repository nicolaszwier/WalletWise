//
//  TransactionListItemView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct TransactionsListItemView: View {
    let transaction: Transaction
    let onDelete: () async -> Void
    @StateObject private var viewModel = TransactionsViewViewModel()
    @State private var editingTransaction = Transaction(id: "", periodId: "", planningId: "", userId: "")
   
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(alignment: .bottom) {
                    Text(transaction.category.rawValue)
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
//                            .padding(.horizontal, 4.0)
//                          .padding(.vertical, 1)
//                            .background(Color(hue: 0.003, saturation: 0.149, brightness: 1.0))
//                            .foregroundColor(Color(hue: 0.001, saturation: 1.0, brightness: 0.428))
//                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    Spacer()
                }
                    
            }
           
            Spacer()
            Text(viewModel.formatCurrency(amount: transaction.amount))
        }
//        .padding(.vertical, 2)
        .swipeActions(edge: .leading) {
            Button {
                Task {
                    await viewModel.payTransaction(transaction:transaction)
                }
            } label: {
                Label("Flag", systemImage: "checkmark.circle.fill")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                Task {
                    await viewModel.removeTransaction(periodId: transaction.periodId ?? "", transactionId: transaction.id ?? "")
                    await onDelete()
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
        .sheet(isPresented: $viewModel.isPresentingEditTransactionView){
            
            NavigationStack {
                EditTransactionView(transaction: $editingTransaction, editTransactionPresented: $viewModel.isPresentingEditTransactionView)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                viewModel.isPresentingEditTransactionView = false
                            }
                        }
                    }
            }
            
        }
    }
    
    
}

#Preview {
    TransactionsListItemView(transaction: Transaction(id: "", periodId: "", planningId: "", userId: "", description: "Transaction description", category: Category.shopping, isPaid: false), onDelete: {
        
    })
}
