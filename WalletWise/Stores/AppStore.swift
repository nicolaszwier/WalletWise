//
//  StorageService.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 07/05/24.
//

import Foundation

class AppStore {
    private var token: String = ""
    private var planningId: String = ""
    
    static let shared = AppStore()
    init() {
        loadStore()
    }
    
    private func loadStore() {
        token = UserDefaults.standard.string(forKey: Constants.UserDefaults.token) ?? ""
    }
    
    func setToken(value: String) {
         token = value
         UserDefaults.standard.setValue(token, forKey: Constants.UserDefaults.token)
    }
    
    func getToken() -> String {
        return token
    }

}
