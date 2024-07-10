//
//  IconCircleView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 23/05/24.
//

import SwiftUI

struct IconCircleView: View {
    let icon: String

    let circleColor: Color
    let imageColor: Color // Remove this for an image in your assets folder.
    let frameSize: CGFloat
    var squareSide: CGFloat {
        1.2.squareRoot() * frameSize
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(circleColor)
                .frame(width: frameSize * 2, height: frameSize * 2)
            
            Image(systemName: icon)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(imageColor)
        }
        
    }
}

#Preview {
    IconCircleView(icon: "cart.fill", circleColor: .blue, imageColor: .white, frameSize: 25)
}
