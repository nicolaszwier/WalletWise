//
//  UserModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/05/24.
//

import Foundation

class UserModel {
    
    func fetch() async throws -> User  {
        
        guard let request = try? HttpService().buildUrlRequest(method: "GET", endpoint: Constants.ApiConstants.Users.getProfile) else {
            throw NetworkError.invalidURL
        }
      
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        do {
            let response = try HttpService().customDecoder().decode(User.self, from: data)
            return response
        }
        catch {
            print(String(data: data, encoding: .utf8)!)
            print("error", error)
            try handleError(data: data, statusCode: nil)
        }
        
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
