//
//  PlanningsModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import Foundation

class PlanningsModel {
    
    func fetch() async throws -> [Planning]  {
        
        guard let request = try? HttpService().buildUrlRequest(method: "GET", endpoint: Constants.ApiConstants.Plannings.getPlannings) else {
            throw NetworkError.invalidURL
        }
      
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        do {
            let response = try HttpService().customDecoder().decode([Planning].self, from: data)
            return response
        }
        catch {
            print(String(data: data, encoding: .utf8)!)
            print("error", error)
            try handleError(data: data, statusCode: nil)
        }
        
        return []
      }
    
    func save(planning: Planning) async throws -> Planning {
        
        guard var request = try? HttpService().buildUrlRequest(method: "POST", endpoint: Constants.ApiConstants.Plannings.postPlanning, params: []) else {
            throw NetworkError.invalidURL
        }
        
        request.httpBody = try? HttpService().customEncoder().encode(planning)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        let decodedResponse = try? HttpService().customDecoder().decode(Planning.self, from: data)
        
        if !(decodedResponse?.id == nil) {
            return decodedResponse!
        }
        
        try handleError(data: data, statusCode: nil)
        
        throw NetworkError.noData
    }
    
    func update(planning: Planning) async throws -> DefaultResponse? {
        
        guard var request = try? HttpService().buildUrlRequest(method: "PUT", endpoint: Constants.ApiConstants.Plannings.putPlanning, params: [planning.id]) else {
            throw NetworkError.invalidURL
        }
        
        request.httpBody = try? HttpService().customEncoder().encode(planning)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        let decodedResponse = try? HttpService().customDecoder().decode(DefaultResponse.self, from: data)
        
        if (decodedResponse?.statusCode ?? 400) >= 200 && (decodedResponse?.statusCode ?? 400) <= 299 {
            return decodedResponse!
        }
        
        try handleError(data: data, statusCode: decodedResponse?.statusCode ?? nil)
        
        return nil
    }
    
    
    func remove(planningId: String) async throws -> DefaultResponse {
        
        guard var request = try? HttpService().buildUrlRequest(method: "DELETE", endpoint: Constants.ApiConstants.Plannings.deletePlanning, params: [planningId]) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        let decodedResponse = try? HttpService().customDecoder().decode(DefaultResponse.self, from: data)
        
        if (decodedResponse?.statusCode ?? 400) >= 200 && (decodedResponse?.statusCode ?? 400) <= 299 {
            return decodedResponse!
        }
        
        try handleError(data: data, statusCode: decodedResponse?.statusCode ?? nil)
        
        throw NetworkError.noData
    }
    
    func handleError(data: Data, statusCode: Int?) throws {
        var code = statusCode
        var errorResponse: ErrorResponse?
        
        if statusCode == nil {
            errorResponse = try HttpService().customDecoder().decode(ErrorResponse.self, from: data)
            code = errorResponse?.statusCode ?? 0
        }
        
        switch code {
        case 401:
            throw AuthenticationError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500:
            throw NetworkError.internalServerError
        default:
            throw NetworkError.custom(errorMessage: errorResponse?.message ?? "Bad request")
        }
    }
    
    
}
