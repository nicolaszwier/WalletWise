//
//  HttpService.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

class HttpService {
    
    let baseUrl: String = Constants.ApiConstants.apiBaseUrl
   
    func getToken() -> String {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            return ""
        }
        return "Bearer \(token)"
    }
    
    func setToken(token: String) {
         UserDefaults.standard.setValue(token, forKey: "token")
    }
    
    
    func buildUrlRequest(method: String, endpoint: String, params: [String] = []) throws -> URLRequest {

        let url = try buildUrl(endpoint: endpoint, apiParams: params)
        let token = getToken()
//        guard !token.isEmpty else {
//            throw AuthenticationError.missingToken
//        }
        print("url", url)
         
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func buildUrl(endpoint: String, apiParams: [String] = []) throws -> URL {
      
        let apiEndpoint = try replaceParams(in: endpoint, with: apiParams)
        
        print("endpoint", apiEndpoint)
        
        guard let url = URL(string: "\(baseUrl)\(apiEndpoint)") else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    func replaceParams(in endpoint: String, with apiParams: [String]) throws -> String {
        var replacedEndpoint = endpoint
        
        // Count the number of placeholders in the endpoint string
        let numberOfPlaceholders = replacedEndpoint.components(separatedBy: "{{").count - 1
        
        // Check if the number of placeholders matches the number of apiParams
        guard numberOfPlaceholders == apiParams.count else {
            throw NetworkError.invalidEndpointParams
        }
        
        // Replace each placeholder with the corresponding apiParam
        for param in apiParams {
            if let range = replacedEndpoint.range(of: "{{") {
                let startIdx = range.lowerBound
                if let endIdx = replacedEndpoint[startIdx...].range(of: "}}")?.upperBound {
                    let placeholderRange = startIdx..<endIdx
                    let placeholder = String(replacedEndpoint[placeholderRange])
                    replacedEndpoint.replaceSubrange(placeholderRange, with: param)
                }
            }
        }
        
        return replacedEndpoint
    }
    
    func customDecoder() -> JSONDecoder {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        
        return decoder
    }
    
}
