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
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}

struct SignupResponse: Codable {
    let accessToken: String?
    let message: String?
    let error: String?
    let statusCode: Int?
}
