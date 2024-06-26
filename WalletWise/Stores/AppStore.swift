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
        token = UserDefaults.standard.string(forKey: "token") ?? ""
        planningId = UserDefaults.standard.string(forKey: "planningId") ?? ""
    }
    
    func setToken(value: String) {
         token = value
         UserDefaults.standard.setValue(token, forKey: "token")
    }
    
    func getToken() -> String {
        return token
    }

    func setPlanningId(value: String) {
        print("setPlanningId", value)
         planningId = value
         UserDefaults.standard.setValue(planningId, forKey: "planningId")
    }
    
    func getPlanningId() -> String {
        return planningId
    }

}
