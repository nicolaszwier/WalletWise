//
//  RoundedTextFieldStyle.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 03/06/24.
//

import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    
    @State var icon: Image?
    @State var verticalPadding: CGFloat?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundColor(Color(UIColor.systemGray4))
                    .padding(.trailing, 6)
            }
            configuration
        }
        .padding(.vertical, verticalPadding ?? 12)
        .padding(.horizontal, 24)
        .background(
            Color(UIColor.systemGray6)
        )
        .clipShape(Capsule(style: .continuous))
    }
}
