//
//  PeriodModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

struct Period: Hashable, Codable, Identifiable {
    let id: String
    let planningId: String
    let userId: String
    let periodBalance: Decimal
    let expectedAllTimeBalance: Decimal
    let periodStart: Date
    let periodEnd: Date
    let transactions: [Transaction]
    
    static func ==(lhs: Period, rhs: Period) -> Bool {
          return lhs.periodStart == rhs.periodStart && lhs.periodEnd == rhs.periodEnd
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(periodStart)
            hasher.combine(periodEnd)
        }
}
