//
//  PlanningStore.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 04/07/24.
//

import Foundation
import SwiftUI

class PlanningStore: ObservableObject {
    let emptyPlanning = Planning(id: "", description: "", currency: Currency.brl, currentBalance: 0, expectedBalance: 0)
    @Published var planning: Planning?
    
    init() {
        self.planning = getSelectedPlanning()
    }
    
    var expectedBalanceBinding: Binding<Decimal> {
        Binding(
            get: { self.planning?.expectedBalance ?? 0 },
            set: { newValue in
                if self.planning == nil {
                    self.planning = self.emptyPlanning
                }
                self.planning?.expectedBalance = newValue
                self.setSelectedPlanning(planning: self.planning ?? self.emptyPlanning)
            }
        )
    }
    
    var currentBalanceBinding: Binding<Decimal> {
        Binding(
            get: { self.planning?.currentBalance ?? 0 },
            set: { newValue in
                if self.planning == nil {
                    self.planning = self.emptyPlanning
                }
                self.planning?.currentBalance = newValue
                self.setSelectedPlanning(planning: self.planning ?? self.emptyPlanning)
            }
        )
    }
    
    func updatePlanningCurrentBalance(currentBalance: Decimal) -> Void {
        withAnimation(){
            DispatchQueue.main.async {
                self.planning?.expectedBalance = currentBalance
                self.setSelectedPlanning(planning: self.planning ?? self.emptyPlanning)
            }
        }
    }
    
    
    func updatePlanningExpectedBalance(expectedBalance: Decimal) -> Void {
        withAnimation(){
            DispatchQueue.main.async {
                self.planning?.expectedBalance = expectedBalance
                self.setSelectedPlanning(planning: self.planning ?? self.emptyPlanning)
            }
        }
    }
    
    func setSelectedPlanning(planning: Planning) -> Void {
        withAnimation(){
            DispatchQueue.main.async {
                self.planning = planning
            }
        }
        
        do {
            // Create JSON Encoder
            let encoder = HttpService().customEncoder()
            
            // Encode Note
            let data = try encoder.encode(planning)
            
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.selectedPlanning)
            
        } catch {
            print("Unable to encode (\(error))")
        }
    }
    
    func getSelectedPlanning() -> Planning? {
        if let data = UserDefaults.standard.data(forKey: Constants.UserDefaults.selectedPlanning) {
            do {
                // Create JSON Decoder
                let decoder = HttpService().customDecoder()
                
                // Decode Note
                let planning = try decoder.decode(Planning.self, from: data)
                self.planning = planning
                return planning
            } catch {
                print("Unable to decode (\(error))")
                return nil
            }
        } else {
            return nil
        }
    }
}
