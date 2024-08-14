//
//  DuplicateTransactionListItem.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 25/07/24.
//

import SwiftUI

struct DuplicateTransactionListItemView: View {
    @Binding var transaction: Transaction
    @EnvironmentObject var planningStore: PlanningStore
    
    var body: some View {
        HStack {
            IconRoundedRectangleView(icon: transaction.category.icon ?? "ellipsis.circle.fill", circleColor: Color(UIColor.secondarySystemFill), imageColor: .primary, frameSize: 16)
                .padding(.trailing, 6)
            VStack {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        TextField("", text: $transaction.description)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    TextField("0,00", value: $transaction.amount, format: .currency(code: Locale.current.identifier))
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(.decimalPad)
                        .bold()
                        .font(.headline)
                        .onAppear(perform: {
                            //if expense, convert the value to show as positive (logic will be handled by API)
                            if transaction.type == TransactionType.expense &&  transaction.amount ?? 0 < 0 {
                                transaction.amount = (transaction.amount ?? 0) * -1
                            }
                            
                            transaction.isPaid = false
                        })
                }
                .contentShape(Rectangle())
                            DatePicker("", selection: $transaction.date, displayedComponents: [.date])
                                .foregroundStyle(.secondary)
            }
        }
    }
    
}

#Preview {
    DuplicateTransactionListItemView(transaction: .constant(Transaction(id: "sdfds2", periodId: "sdfsd", categoryId: "sfsd", planningId: "sdfsd", userId: "sfd", amount: 100, description: "Grocery store", category: Category(id: "", description: "Shopping", icon: "dollarsign.circle.fill", userId: "sdfsfwe", active: true, type: TransactionType.expense), date: Date.now, isPaid: true)))
        .environmentObject(PlanningStore())
}
