//
//  ErrorEntity.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 02/05/24.
//

import Foundation

struct ErrorResponse: Codable {
    let message: String?
    let error: [String]?
    let statusCode: Int?
}

struct DefaultResponse: Codable {
    let message: String?
    let error: String?
    let statusCode: Int?
}
