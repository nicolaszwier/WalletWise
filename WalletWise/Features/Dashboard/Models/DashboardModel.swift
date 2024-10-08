//
//  DashboardModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 04/08/24.
//

import Foundation

class DashboardModel {
    
    func fetchExpiringTransactions(planningId: String) async throws -> [Transaction] {
        guard let request = try? HttpService().buildUrlRequest(method: "GET", endpoint: Constants.ApiConstants.Transactions.getPendingTransactionsDueInAWeek, params: [planningId]) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        if let response = try? HttpService().customDecoder().decode([Transaction].self, from: data) {
            return response
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
