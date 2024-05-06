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
    
    func fetchPlannings() {
        self.isLoading = true;
        PlanningsModel().fetch()  { (result) in
            switch result {
                case .success(let plannings):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(){
                            self.isLoading = false;
                            self.plannings = plannings
                           
                        }
                    }
                case .failure(let error):
                    print("error", error)
                    self.isLoading = false;
                }
           
        }
    }
}
