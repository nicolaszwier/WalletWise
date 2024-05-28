//
//  CategoryEntity.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 23/05/24.
//

import Foundation
import SwiftUI

struct Category: Hashable, Codable, Identifiable {
    let id: String?
    let description: String
    let icon: String?
    let userId: String?
    let active: Bool?
//    let color: String?
//    
//    var uiColor: Color? {
//           guard let colorString = color else { return nil }
//           return Color(colorString)
//       }
    
}
