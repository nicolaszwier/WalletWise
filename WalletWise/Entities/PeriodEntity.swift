//
//  PeriodModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

struct Period: Hashable, Codable, Identifiable {
    var id: String
    var planningId: String
    var userId: String
    var periodBalance: Decimal
    var periodBalancePaidOnly: Decimal
    var expectedAllTimeBalance: Decimal
    var expectedAllTimeBalancePaidOnly: Decimal
    var periodStart: Date
    var periodEnd: Date
    var transactions: [Transaction]
    
    static func ==(lhs: Period, rhs: Period) -> Bool {
          return lhs.periodStart == rhs.periodStart && lhs.periodEnd == rhs.periodEnd
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(periodStart)
            hasher.combine(periodEnd)
        }
}
