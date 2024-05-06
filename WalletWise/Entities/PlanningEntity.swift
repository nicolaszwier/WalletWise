//
//  SignupModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

enum Currency: String, Codable {
    case brl = "BRL", cad = "CAD"
}

struct Planning: Hashable, Codable, Identifiable {
    let id: String
    let description: String
    let currency: Currency
    let initialBalance: Decimal
    let dateOfCreation: Date
}
