//
//  BalanceEntity.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 14/10/24.
//

import Foundation

struct Balance: Hashable, Codable {
//    var id: String
    var month: Int
    var year: Int
    var incomes: Decimal
    var incomesPaidOnly: Decimal
    var expenses: Decimal
    var expensesPaidOnly: Decimal
    var categories: [BalanceCategory]
}

struct BalanceCategory: Hashable, Codable {
    var categoryId: String
    var type: TransactionType
    var description: String
    var balance: Decimal
    var balancePaidOnly: Decimal
}
