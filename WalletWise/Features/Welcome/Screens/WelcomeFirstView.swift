//
//  WelcomeFirstView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 13/08/24.
//

import SwiftUI

struct WelcomeFirstView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                Image("AppIcon-WW")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .frame(height: 90)
                    .padding(.bottom, 36)
                
                Text("Welcome to WalletWise!")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("WalletWise is a simple personal finances tracker that helps you to plan your budget weekly. ")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                
                HStack {
                    Spacer()
                    NavigationLink(destination: WelcomeSecondView() .navigationBarHidden(true),
                                   label: {
                        HStack(spacing: 8) {
                            Text("Next")
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.right")
                                .fontWeight(.semibold)
                            
                        }
                    })
                    .buttonStyle(BorderedButtonStyle())
                    .toolbar(.hidden)
                }
                .padding(.horizontal)
            }
            .padding(.all)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

#Preview {
    WelcomeFirstView()
}
