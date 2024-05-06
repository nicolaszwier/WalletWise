//
//  TimelineViewViewModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 02/05/24.
//

import Foundation
import SwiftUI

class TimelineViewViewModel: ObservableObject {
    @Published var periods: [Period] = []
    @Published var isLoading: Bool = false
    @Published var isPresentingNewTransactionView = false
    @Published var isPresentingFiltersView = false
    let planningId: String
    
    init(planningId: String) {
        self.planningId = planningId
    }
    
    func fetch() async {
        
        guard !self.planningId.isEmpty else {
            print("planningId is empty")
            return
        }
        
        self.isLoading = true;
     
        do {
            let response = try await TimelineModel().fetch(planningId: self.planningId)
            DispatchQueue.main.async {
                self.periods = response
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                print("Error fetching data: \(error)")
                self.isLoading = false;
            }
        }

    }
    
    func formattedDate(date: Date) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMMM d"
           return dateFormatter.string(from: date)
    }
    
    func formatCurrency(amount: Decimal) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            
            return formatter.string(from: amount as NSDecimalNumber) ?? ""
    }
}
