//
//  SignupModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 05/06/24.
//

import Foundation


class SignupModel {
    
    func signup(data: SignupRequest) async throws -> SignupResponse {
        
        guard var request = try? HttpService().buildUrlRequest(method: "POST", endpoint: Constants.ApiConstants.Auth.signup, params: []) else {
            throw NetworkError.invalidURL
        }
        
        request.httpBody = try? HttpService().customEncoder().encode(data)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            throw NetworkError.custom(errorMessage: "Invalid HTTPUrlResponse")
        }
        print(String(data: data, encoding: .utf8)!)
        let decodedResponse = try? HttpService().customDecoder().decode(SignupResponse.self, from: data)
        
        if (decodedResponse?.accessToken != nil) {
            return decodedResponse!
        }
        
        try HttpService().handleError(data: data, statusCode: decodedResponse?.statusCode ?? nil)
        
        throw NetworkError.noData
    }
      
}
