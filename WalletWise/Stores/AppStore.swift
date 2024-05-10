//
//  StorageService.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 07/05/24.
//

import Foundation

class AppStore: ObservableObject {
    @Published private(set) var planningId: String = ""
    @Published private(set) var token: String = ""
    
    func setToken(value: String) {
         token = value
         UserDefaults.standard.setValue(token, forKey: "token")
    }

    func loadStore() {
        token = UserDefaults.standard.string(forKey: "token") ?? ""
        planningId = UserDefaults.standard.string(forKey: "planningId") ?? ""
    }
    
    
}
