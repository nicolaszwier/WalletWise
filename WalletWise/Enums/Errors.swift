//
//  Errors.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import Foundation

enum AuthenticationError: Error {
    case unauthorized
    case invalidCredentials
    case custom(errorMessage: String)
    case invalidURL
    case missingToken
    case emailTaken
}

enum NetworkError: Error {
    case invalidURL
    case invalidEndpointParams
    case noData
    case decodingError
    case custom(errorMessage: String)
    case badRequest
    case internalServerError
    case notFound
}
