//
//  WWButton.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 09/05/24.
//

import SwiftUI

struct WWButton: View {
    @State private var isPressed = false
    @Binding var isLoading: Bool
    let label: String
    let background: Color
    let action: () -> Void
    var body: some View {
//        Button(label) {
//            isPressed.toggle()
//            action()
//        }
//        .sensoryFeedback(.start, trigger: isPressed)
//        .frame(height: 42.0)
//        .fontWeight(.heavy)
//        .frame(maxWidth: /*@START_MENU_TOKEN@*/.greatestFiniteMagnitude/*@END_MENU_TOKEN@*/)
//        .background(background)
//        .foregroundColor(.white)
//        .clipShape(RoundedRectangle(cornerRadius: 8, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
//        
        Button(action: {
            isPressed.toggle()
            action()
        }) {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 32.0)
            } else {
                Text(label)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32.0)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(BorderedProminentButtonStyle())
    }
}

#Preview {
    WWButton(isLoading: .constant(true), label: "Label", background: .accentColor, action: {
        
    })
}
