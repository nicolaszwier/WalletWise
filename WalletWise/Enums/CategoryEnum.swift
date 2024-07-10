//
//  CategoryModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation
import SwiftUI

enum CategoryEnum: String, Codable, CaseIterable {
    case groceries = "Groceries",
         transportation = "Transportation",
         entertainment = "Entertainment",
         shopping = "Shopping",
         dining = "Dining",
         home = "Home",
         income = "Income",
         empty = "Empty"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

  
