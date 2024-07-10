//
//  FiltersEntity.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 20/05/24.
//

import Foundation

struct FiltersEntity: Codable, Hashable {
    var selectedPeriod: FilterPeriod
    var startDate: Date
    var endDate: Date
    var includeExpenses: Bool
    var includeIncomes: Bool
    
    init(selectedPeriod: FilterPeriod = FilterPeriod.custom, startDate: Date = UtilsService().addOrSubtractMonth(month: -1), endDate: Date = UtilsService().addOrSubtractMonth(month: 2), includeExpenses: Bool = true, includeIncomes: Bool = true) {
        self.selectedPeriod = selectedPeriod
        self.startDate = startDate
        self.endDate = endDate
        self.includeExpenses = includeExpenses
        self.includeIncomes = includeIncomes
    }
    
    
   
}
