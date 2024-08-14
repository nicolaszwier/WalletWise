//
//  DashboardViewViewModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 03/08/24.
//

import Foundation
import SwiftUI

@MainActor
class DashboardViewViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var expiringTransactions: [Transaction] = []
   
    func fetchExpiringTransactions(planningId: String) async {
        do {
            self.loader(show: true)
            let response = try await DashboardModel().fetchExpiringTransactions(planningId: planningId)            
            withAnimation(){
                DispatchQueue.main.async {
                    self.expiringTransactions = response
                    self.loader(show: false)
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("Error fetching data: \(error)")
                self.loader(show: false)
            }
        }
    }
    
    private func loader(show: Bool) {
        DispatchQueue.main.async {
            self.isLoading = show;
        }
    }
}
