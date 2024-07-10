//
//  UtilsService.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 02/05/24.
//

import Foundation

class UtilsService {
    
    func addOrSubtractDay(day:Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: Date())!
    }
    
    func addOrSubtractMonth(month:Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: month, to: Date())!
    }
    
    func addOrSubtractYear(year:Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: year, to: Date())!
    }
}
