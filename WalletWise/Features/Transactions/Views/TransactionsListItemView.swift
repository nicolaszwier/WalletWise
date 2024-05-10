//
//  TransactionListItemView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct TransactionsListItemView: View {
    @StateObject private var viewModel = TransactionsViewViewModel()
    let transaction: Transaction
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
//            systemImage: "dollarsign.circle"
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
//                            .padding(.horizontal, 7.0)
//                            .background(Color(hue: 0.381, saturation: 0.149, brightness: 1.0))
                            .foregroundColor(Color.green)
                    }
                    if !transaction.isPaid {
                        Label("Pending", systemImage: "exclamationmark.circle.fill")
//                            .frame(height: 18.0)
                            .font(.caption)
                            .padding(.horizontal, 7.0)
//                          .padding(.vertical, 1)
                            .background(Color(hue: 0.003, saturation: 0.149, brightness: 1.0))
                            .foregroundColor(Color(hue: 0.001, saturation: 1.0, brightness: 0.428))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }
                    
            }
           
            Spacer()
            Text(viewModel.formatCurrency(amount: transaction.amount))
        }
        .padding(.vertical, 7)
        .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                Button {
                    
                } label: {
                    Label("Flag", systemImage: "pencil.circle")
                }
                .tint(.blue)
            }
    }
}

#Preview {
    TransactionsListItemView(transaction: Transaction(id: "", periodId: "", planningId: "", userId: "", description: "Transaction description", category: Category.shopping, isPaid: true))
}
