//
//  SigninModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

struct SigninRequest: Codable {
    let email: String
    let password: String
}

struct SigninResponse: Codable {
    let accessToken: String?
    let message: String?
    let error: String?
    let statusCode: Int?
}

struct SignupRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct SignupResponse: Codable {
    let accessToken: String?
    let message: String?
    let error: String?
    let statusCode: Int?
}
