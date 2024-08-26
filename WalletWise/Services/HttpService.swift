//
//  HttpService.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

class HttpService {
    let appStore: AppStore = AppStore()
    let baseUrl: String = Constants.ApiConstants.apiBaseUrl
    
    func getToken() -> String {
        let token = AppStore.shared.getToken()
        if token.isEmpty {
            return ""
        }
        return "Bearer \(token)"
    }
    
    func buildUrlRequest(method: String, endpoint: String, params: [String] = [], queryParams: [URLQueryItem] = []) throws -> URLRequest {
        
        let url = try buildUrl(endpoint: endpoint, apiParams: params, queryParams: queryParams)
        let token = getToken()
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func buildUrl(endpoint: String, apiParams: [String] = [], queryParams: [URLQueryItem] = []) throws -> URL {
        
        let apiEndpoint = try replaceParams(in: endpoint, with: apiParams)
        
        guard var url = URL(string: "\(baseUrl)\(apiEndpoint)") else {
            throw NetworkError.invalidURL
        }
        if !queryParams.isEmpty {
            url.append(queryItems: queryParams)
        }
        
        print("url", url.absoluteString)
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
                    _ = String(replacedEndpoint[placeholderRange])
                    replacedEndpoint.replaceSubrange(placeholderRange, with: param)
                }
            }
        }
        
        return replacedEndpoint
    }
    
    func handleError(data: Data, statusCode: Int?) throws {
        var code = statusCode
        var errorResponse: ErrorResponse?
        var errorResponseAlt: ErrorResponseAlt?
        
        if statusCode == nil {
            errorResponse = try? HttpService().customDecoder().decode(ErrorResponse.self, from: data)
            code = errorResponse?.statusCode ?? 0
        }
        
        if  statusCode == nil && errorResponse == nil {
            errorResponseAlt = try? HttpService().customDecoder().decode(ErrorResponseAlt.self, from: data)
            code = errorResponseAlt?.statusCode ?? 0
        }
        
        switch code {
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw AuthenticationError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 409:
            throw AuthenticationError.emailTaken
        case 500:
            throw NetworkError.internalServerError
        default:
            throw NetworkError.custom(errorMessage: errorResponse?.message ?? "Unidentified error code")
        }
    }
    
    func customDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let components = dateString.components(separatedBy: ".")
            let dateStr = components.first ?? ""
            let date = Date(isoString: dateStr)
            return date!
        }
        return decoder
    }
    
    func customEncoder() -> JSONEncoder {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter)
        return encoder
    }
}

extension Date {
    init?(isoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = formatter.date(from: isoString) {
            self.init(timeInterval: 0, since: date)
        } else {
            return nil
        }
    }
}
