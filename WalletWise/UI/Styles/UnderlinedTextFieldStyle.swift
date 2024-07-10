//
//  UnderlinedTextFieldStyle.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 03/06/24.
//

import SwiftUI

struct UnderlinedTextFieldStyle: TextFieldStyle {
    
    @State var icon: Image?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundColor(Color(UIColor.systemGray4))
                    .padding(.trailing, 6)
            }
            configuration
        }
        .padding(.vertical, 8)
        .background(
            VStack {
                Spacer()
                Color(UIColor.systemGray4)
                    .frame(height: 2)
            }
        )
    }
}
