//
//  NewTransactionModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 05/05/24.
//

import Foundation

class TransactionModel {
    
    func save(transaction: Transaction) async throws -> DefaultResponse {
        
        guard var request = try? HttpService().buildUrlRequest(method: "POST", endpoint: Constants.ApiConstants.Transactions.postTransaction, params: []) else {
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
    
    func update(transaction: Transaction) async throws -> DefaultResponse? {
        
        guard var request = try? HttpService().buildUrlRequest(method: "PUT", endpoint: Constants.ApiConstants.Transactions.putTransaction, params: [transaction.id ?? ""]) else {
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
        
        try? handleError(data: data, statusCode: decodedResponse?.statusCode ?? nil)
        
        return nil
    }
    
    func pay(periodId: String, transactionId: String) async throws -> DefaultResponse? {
        
        guard let request = try? HttpService().buildUrlRequest(method: "PUT", endpoint: Constants.ApiConstants.Transactions.payTransaction, params: [periodId, transactionId]) else {
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
        
        return nil
    }
    
    func handleError(data: Data, statusCode: Int?) throws {
        var code = statusCode
        var errorResponse: ErrorResponse?
        
        if statusCode == nil {
            errorResponse = try? HttpService().customDecoder().decode(ErrorResponse.self, from: data)
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
    
    
    func remove(periodId: String, transactionId: String) async throws -> DefaultResponse {
        
        guard let request = try? HttpService().buildUrlRequest(method: "DELETE", endpoint: Constants.ApiConstants.Transactions.deleteTransaction, params: [periodId, transactionId]) else {
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
