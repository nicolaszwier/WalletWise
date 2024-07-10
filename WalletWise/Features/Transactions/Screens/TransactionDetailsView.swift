//
//  TransactionDetailsView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 11/05/24.
//

import SwiftUI

struct TransactionDetailsView: View {
    let transaction: Transaction
    var body: some View {
        Text(transaction.description)
        Text(transaction.amount.formatted())
        Text(transaction.date.formatted())
    }
}

#Preview {
    TransactionDetailsView(transaction: Transaction(id: "", periodId: "", categoryId: "", planningId: "", userId: "", amount: 25, description: "Groceries", date: Date.now))
}
