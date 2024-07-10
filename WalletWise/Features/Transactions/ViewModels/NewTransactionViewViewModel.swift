//
//  NewTransactionViewViewModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 04/05/24.
//

import Foundation
import SwiftUI

class NewTransactionViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var isLoading: Bool = false
    @Published var success: Bool = false
    @Published var newTransaction = Transaction(id: "", periodId: "", categoryId: "", planningId: AppStore.shared.getPlanningId(), userId: "", amount: 10)
//    
//    init() {
////        self.planningId = planningId
//        print("newTransaction", newTransaction)
//    }
    

    
  
    
}
