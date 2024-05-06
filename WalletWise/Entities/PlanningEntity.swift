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

struct Planning: Codable {
    let id: String
    let description: String
    let currency: Currency
    let dateOfCreation: Date
}
