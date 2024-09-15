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

        Button(action: {
            isPressed.toggle()
            action()
        }) {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 32.0)
            } else {
                Text(NSLocalizedString(label, comment: ""))
                    .frame(maxWidth: .infinity)
                    .frame(height: 32.0)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            }
        }
        .sensoryFeedback(.start, trigger: isPressed)
        .buttonStyle(BorderedProminentButtonStyle())
    }
}

#Preview {
    WWButton(isLoading: .constant(false), label: "Label", background: .accentColor, action: {
        
    })
}
