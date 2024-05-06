//
//  TransactionModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

enum TransactionType: String, Codable {
    case expense = "EXPENSE", income = "INCOME"
}

struct Transaction: Codable {
    let id: String
    let periodId: String
    let planningId: String
    let userId: String
    let amount: Double
    let description: String
    let category: Category
    let date: Date
    let isPaid: Bool
    let type: TransactionType
    let dateCreated: Date
}
