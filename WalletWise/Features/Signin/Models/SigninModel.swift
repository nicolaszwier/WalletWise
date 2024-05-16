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
        
        if let response = try? HttpService().customDecoder().decode(SigninResponse.self, from: data) {
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
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//          
//          guard let data = data, error == nil else {
//              completion(.failure(.custom(errorMessage: "No data")))
//              return
//          }
//          
//          guard let loginResponse = try? JSONDecoder().decode(SigninResponse.self, from: data) else {
//              completion(.failure(.invalidCredentials))
//              return
//          }
//          
//            guard let token = loginResponse.accessToken else {
//              completion(.failure(.invalidCredentials))
//              return
//          }
//          
//          completion(.success(token))
//          
//        }.resume()
          
      }
      
}
