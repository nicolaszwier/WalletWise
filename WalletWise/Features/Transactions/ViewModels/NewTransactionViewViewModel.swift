//
//  NewTransactionViewViewModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 04/05/24.
//

import Foundation

class NewTransactionViewViewModel: ObservableObject {
    var planningId: String
    @Published var errorMessage = ""
    @Published var isLoading: Bool = false
    
    @Published var newTransaction = Transaction(id: nil, periodId: nil, planningId: "", userId: nil)
    
    init(planningId: String) {
        self.planningId = planningId
        print("planning id init", self.planningId)
    }
    
    
    func submit() async  {
        self.isLoading = true;
        do {
            print("newTransaction", newTransaction)
            let response = try await NewTransactionModel().save(transaction: newTransaction)
//            if let accessToken = response.accessToken {
                DispatchQueue.main.async {
                        print("success")
                        self.isLoading = false;
                }
//            }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
                self.isLoading = false;
                self.errorMessage = "Error on submitting transaction"
            }
        }
    }
    
  
    
}
