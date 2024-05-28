//
//  TimelineModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 02/05/24.
//

import Foundation

class TimelineModel {
    
    func fetch(planningId: String, filters: FiltersEntity) async throws -> [Period] {
        let queryParams = self.transformFiltersToQueryParams(filters: filters)
        guard let request = try? HttpService().buildUrlRequest(method: "GET", endpoint: Constants.ApiConstants.Periods.getPeriods, params: [planningId], queryParams: queryParams) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        if let response = try? HttpService().customDecoder().decode([Period].self, from: data) {
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
    
    private func transformFiltersToQueryParams(filters: FiltersEntity) -> [URLQueryItem] {
        var result: [URLQueryItem] = []
        if filters.selectedPeriod.rawValue == FilterPeriod.lastMonth.rawValue {
            result.append(URLQueryItem(name: "startDate", value: UtilsService().addOrSubtractMonth(month: -1).ISO8601Format()))
            result.append(URLQueryItem(name: "endDate", value: UtilsService().addOrSubtractDay(day: 7).ISO8601Format()))
        }
        if filters.selectedPeriod.rawValue == FilterPeriod.lastThreeMonths.rawValue {
            result.append(URLQueryItem(name: "startDate", value: UtilsService().addOrSubtractMonth(month: -3).ISO8601Format()))
            result.append(URLQueryItem(name: "endDate", value: UtilsService().addOrSubtractDay(day: 7).ISO8601Format()))
        }
        if filters.selectedPeriod.rawValue == FilterPeriod.custom.rawValue {
            result.append(URLQueryItem(name: "startDate", value: filters.startDate.ISO8601Format()))
            result.append(URLQueryItem(name: "endDate", value: filters.endDate.ISO8601Format()))
        }
        result.append(URLQueryItem(name: "includeExpenses", value: filters.includeExpenses.description))
        result.append(URLQueryItem(name: "includeIncomes", value: filters.includeIncomes.description))
        
        return result
    }
    
}
