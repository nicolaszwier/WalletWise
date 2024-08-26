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
    
    func signout() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.selectedPlanning)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.token)
    }
}
