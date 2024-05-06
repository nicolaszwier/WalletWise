//
//  NewTransactionModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 05/05/24.
//

import Foundation

class NewTransactionModel {
    
    func save(transaction: Transaction) async throws -> [Period] {
        
        guard var request = try? HttpService().buildUrlRequest(method: "POST", endpoint: Constants.ApiConstants.Transactions.postTransactions, params: []) else {
            throw NetworkError.invalidURL
        }
        print("1")
        request.httpBody = try? JSONEncoder().encode(transaction)
        print("2")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        print("3")
        if let response = try? HttpService().customDecoder().decode([Period].self, from: data) {
            return response
        }
        print("4")
        let errorResponse = try HttpService().customDecoder().decode(ErrorResponse.self, from: data)
        
        switch errorResponse.statusCode {
        case 401:
            throw AuthenticationError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500:
            throw NetworkError.internalServerError
        default:
            throw NetworkError.custom(errorMessage: errorResponse.message ?? "Bad request")
        }
  
      }
    
}
