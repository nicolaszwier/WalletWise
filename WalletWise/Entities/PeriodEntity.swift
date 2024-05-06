//
//  PeriodModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

struct Period: Codable {
    let id: String
    let planningId: String
    let userId: String
    let periodBalance: Double
    let expectedAllTimeBalance: Double
    let periodStart: Date
    let periodEnd: Date
    let transactions: [Transaction]?
}
