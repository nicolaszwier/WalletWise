//
//  SignupModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

enum Currency: String, Codable {
    case brl = "BRL", cad = "CAD", eur = "EUR", gbp = "GBP", usd = "USD"
}

struct Planning: Hashable, Codable, Identifiable {
    var id: String
    var description: String
    var currency: Currency
    var currentBalance: Decimal
    var expectedBalance: Decimal
    var dateOfCreation: Date?
    var active: Bool?
}
