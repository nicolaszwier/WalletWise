//
//  WWButton.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 09/05/24.
//

import SwiftUI

struct WWButton: View {
    let label: String
    let background: Color
    let action: () -> Void
    var body: some View {
        Button(label) {
           action()
        }
        .frame(height: 37.0)
        .fontWeight(.heavy)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.greatestFiniteMagnitude/*@END_MENU_TOKEN@*/)
        .background(background)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
    }
}

#Preview {
    WWButton(label: "Label", background: .blue, action: {
        
    })
}
