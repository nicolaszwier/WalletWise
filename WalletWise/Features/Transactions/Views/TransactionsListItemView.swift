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
    @EnvironmentObject var planningStore: PlanningStore
    @State private var editingTransaction = Transaction(id: "", periodId: "", categoryId: "", planningId: "", userId: "")
   
    var body: some View {
        HStack {
            IconCircleView(icon: transaction.category.icon ?? "ellipsis.circle.fill", circleColor: Color(UIColor.secondarySystemFill), imageColor: .secondary, frameSize: 16)
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
            Text(transaction.amount.formatted(.currency(code: planningStore.planning?.currency.rawValue ?? "BRL")))
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
            .tint(.red)
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
            }
        }
    }
    
    
}

#Preview {
    TransactionsListItemView(transaction: .constant(Transaction(id: "", periodId: "", categoryId: "", planningId: "", userId: "", description: "Transaction description", category: Category(id: "", description: "Shopping", icon: "dollarsign.circle.fill", userId: "sdfsfwe", active: true, type: TransactionType.expense), isPaid: false)), refreshTrigger: {
        
    }, onEditDismiss: {})
        .environmentObject(PlanningStore())
}
