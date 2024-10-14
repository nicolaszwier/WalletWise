//
//  BalancesModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 14/10/24.
//

import Foundation

class BalancesModel {
    
    func fetchMonthly(planningId: String, year: String, month: String) async throws -> Balance {
        let queryParams = self.transformFiltersToQueryParams(year: year, month: month)
        guard let request = try? HttpService().buildUrlRequest(method: "GET", endpoint: Constants.ApiConstants.Transactions.getMonthlyBalance, params: [planningId], queryParams: queryParams) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        if let response = try? HttpService().customDecoder().decode(Balance.self, from: data) {
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
    
    private func transformFiltersToQueryParams(year: String, month: String) -> [URLQueryItem] {
        var result: [URLQueryItem] = []
        result.append(URLQueryItem(name: "year", value: year))
        result.append(URLQueryItem(name: "month", value: month))
        return result
    }
}
