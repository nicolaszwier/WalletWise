//
//  SigninModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import Foundation

class SigninModel {
    
    func signin(email: String, password: String) async throws -> SigninResponse {
        
        guard var request = try? HttpService().buildUrlRequest(method: "POST", endpoint: Constants.ApiConstants.Auth.signin) else {
            throw NetworkError.invalidURL
        }
        
        let body = SigninRequest(email: email, password: password)
        request.httpBody = try? JSONEncoder().encode(body)
      
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        
        let decodedResponse = try? HttpService().customDecoder().decode(SigninResponse.self, from: data)
        
        if (decodedResponse?.accessToken != nil) {
            return decodedResponse!
        }
        
        try HttpService().handleError(data: data, statusCode: decodedResponse?.statusCode ?? nil)
        
        throw NetworkError.noData
          
      }
      
}
