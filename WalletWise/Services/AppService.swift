//
//  AppStore.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation


class AppService: ObservableObject {
    init() {
        
    }
    
    func setSignedIn(token: String) {
        HttpService().setToken(token: token)
    }
    
    func setSelectedPlanningId(planningId: String) {
        HttpService().setToken(token: token)
    }
    
    func signout() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
}
