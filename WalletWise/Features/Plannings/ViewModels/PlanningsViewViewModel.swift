//
//  PlanningsViewViewModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import Foundation
import SwiftUI

class PlanningsViewViewModel: ObservableObject {
    @Published var plannings: [Planning] = []
    @Published var isLoading: Bool = false
    @Published var formErrors: [String] = []
    @Published var errorMessage = ""
    @Published var isPresentingNewPlannningView = false
    @Published var isPresentingEditPlanningView = false
    @Published var newPlanning: Planning = Planning(id: "1", description: "", currency: Currency.cad, currentBalance: 0, expectedBalance: 0, dateOfCreation: Date())
    
    func fetch() async {
        self.loader(show: true)
        do {
            let response = try await PlanningsModel().fetch()
           
            DispatchQueue.main.async {
                withAnimation(){
                    if response.isEmpty {
                        self.isPresentingNewPlannningView = true
                    }
                    self.plannings = response
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
    
    func save() async  {
        guard isFormValid(planning: self.newPlanning) else {
            print("form invalid", formErrors.count)
            return
        }
        self.loader(show: true)
        do {
            _ = try await PlanningsModel().save(planning: self.newPlanning)
            await self.fetch()
            DispatchQueue.main.async {
                print("success")
                self.loader(show: false)
            }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
                self.loader(show: false)
                self.errorMessage = "Error on submitting planning"
            }
        }
    }
    
    func update(planning: Planning) async  {
        guard isFormValid(planning: planning) else {
            return
        }
        self.loader(show: true)
        do {
            _ = try await PlanningsModel().update(planning: planning)
            DispatchQueue.main.async {
                print("success")
                self.loader(show: false)
            }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
                self.loader(show: false)
                self.errorMessage = "Error on updating planning"
            }
        }
    }
    
    private func isFormValid(planning: Planning) -> Bool {
        self.formErrors.removeAll()
        
        guard !planning.description.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.formErrors.append("Description should not be empty.")
            return false
        }
        
        guard !planning.currency.rawValue.isEmpty else {
            self.formErrors.append("Please select a currency")
            return false
        }
        
        return true
    }
    
    func remove(planningId: String) async  {
        do {
            self.loader(show: true)
            _ = try await PlanningsModel().remove(planningId: planningId)
            DispatchQueue.main.async {
                self.loader(show: false)
                print("success")
                self.plannings.removeAll(where: {$0.id == planningId})
            }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
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
