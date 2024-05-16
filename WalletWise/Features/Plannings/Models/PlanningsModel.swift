//
//  PlanningsModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import Foundation

class PlanningsModel {
    
    func fetch(completion: @escaping (Result<[Planning], NetworkError>) -> Void) {
        
        guard let request = try? HttpService().buildUrlRequest(method: "GET", endpoint: Constants.ApiConstants.Plannings.getPlannings) else {
            completion(.failure(.invalidURL))
            return
        }
      
        URLSession.shared.dataTask(with: request) { (data, response, error) in
          guard let data = data, error == nil else {
              completion(.failure(.noData))
              return
          }
          
            guard let plannings = try? HttpService().customDecoder().decode([Planning].self, from: data) else {
              completion(.failure(.decodingError))
              return
          }
          
          completion(.success(plannings))
          
        }.resume()
          
      }
    
}
