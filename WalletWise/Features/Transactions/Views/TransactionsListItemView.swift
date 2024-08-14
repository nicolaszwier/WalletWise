//
//  TransactionListItemView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct TransactionsListItemView: View {
    @Binding var transaction: Transaction
    var isSelected: Bool
    let toggleSelection: () -> Void
    let refreshTrigger: () async -> Void
    let onEditDismiss: () -> Void
    let allowSelection: Bool
    let allowSwipeActions: Bool
    @StateObject private var viewModel = TransactionsViewViewModel()
    @EnvironmentObject var planningStore: PlanningStore
    @State private var editingTransaction = Transaction(id: "", periodId: "", categoryId: "", planningId: "", userId: "")
    
    var body: some View {
        HStack {
            if isSelected {
                IconRoundedRectangleView(icon: "checkmark.circle.fill", circleColor: .accent, imageColor: .white, frameSize: 16)
                    .padding(.trailing, 4)
            } else {
                IconRoundedRectangleView(icon: transaction.category.icon ?? "ellipsis.circle.fill", circleColor: Color(UIColor.secondarySystemFill), imageColor: .primary, frameSize: 16)
                    .padding(.trailing, 4)
            }
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(alignment: .bottom) {
                    Text("\(viewModel.formattedDate(date: transaction.date))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 1)
                    Text(transaction.category.description)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    if transaction.isPaid {
                        Label("", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(Color.gradientTextSecondary)
                    }
                    if !transaction.isPaid && !viewModel.isOverdue(date: transaction.date){
                        Label("", systemImage: "exclamationmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    if !transaction.isPaid && viewModel.isOverdue(date: transaction.date) {
                        Label("", systemImage: "calendar.badge.exclamationmark")
                            .font(.caption)
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                
            }
            Spacer()
            Text(transaction.amount?.formatted(.currency(code: planningStore.planning?.currency.rawValue ?? "BRL")) ?? "0")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if (allowSelection) {
                withAnimation{
                    toggleSelection()
                }
            }
        }
        .transition(.move(edge: .leading))
        .swipeActions(edge: .leading) {
            
            if !transaction.isPaid && allowSwipeActions {
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
            if (allowSwipeActions) {
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
        }
        .sheet(isPresented: $viewModel.isPresentingEditTransactionView, onDismiss: onEditDismiss){
            
            NavigationStack {
                EditTransactionView(transaction: $editingTransaction, editTransactionPresented: $viewModel.isPresentingEditTransactionView)
            }
        }
    }
    
    
}

#Preview {
    TransactionsListItemView(transaction: .constant(Transaction(id: "", periodId: "", categoryId: "", planningId: "", userId: "", description: "Transaction description", category: Category(id: "", description: "Shopping", icon: "dollarsign.circle.fill", userId: "sdfsfwe", active: true, type: TransactionType.expense), isPaid: false)), isSelected: true, toggleSelection: {}, refreshTrigger: {}, onEditDismiss: {}, allowSelection: true, allowSwipeActions: true)
        .environmentObject(PlanningStore())
    //        .environmentObject(TransactionsViewViewModel())
}
