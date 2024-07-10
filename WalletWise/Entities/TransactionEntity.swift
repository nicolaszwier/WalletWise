//
//  TransactionModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

struct Transaction: Codable, Identifiable, Hashable {
    var id: String?
    var periodId: String?
    var categoryId: String
    var planningId: String
    var userId: String?
    var amount: Decimal
    var description: String
    var category: Category {
        didSet {
            categoryId = category.id ?? ""
        }
    }
    var date: Date
    var isPaid: Bool
    var type: TransactionType
    var dateCreated: Date?
    
    init(id: String?,
         periodId: String?,
         categoryId: String,
         planningId: String,
         userId: String?,
         amount: Decimal = 0,
         description: String = "",
         category: Category = Category(id: "", description: "", icon: "", userId: "", active: true, type: TransactionType.expense),
         date: Date = Date.now,
         isPaid: Bool = true,
         type: TransactionType = TransactionType.expense,
         dateCreated: Date? = Date.now
    ) {
        self.id = id
        self.periodId = periodId
        self.categoryId = categoryId
        self.planningId = planningId
        self.userId = userId
        self.amount = amount
        self.description = description
        self.category = category
        self.date = date
        self.isPaid = isPaid
        self.type = type
        self.dateCreated = dateCreated
    }
}
