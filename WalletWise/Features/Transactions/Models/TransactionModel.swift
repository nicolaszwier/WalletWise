//
//  NewTransactionModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 05/05/24.
//

import Foundation

class TransactionModel {
    
    func save(transaction: Transaction) async throws -> DefaultResponse {
        
        guard var request = try? HttpService().buildUrlRequest(method: "POST", endpoint: Constants.ApiConstants.Transactions.postTransactions, params: []) else {
            throw NetworkError.invalidURL
        }
        
        request.httpBody = try? HttpService().customEncoder().encode(transaction)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        let decodedResponse = try? HttpService().customDecoder().decode(DefaultResponse.self, from: data)
        
        if (decodedResponse?.statusCode ?? 400) >= 200 && (decodedResponse?.statusCode ?? 400) <= 299 {
            return decodedResponse!
        }
        
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
