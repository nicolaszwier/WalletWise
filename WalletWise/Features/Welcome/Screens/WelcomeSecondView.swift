//
//  WelcomeSecondView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 13/08/24.
//

import SwiftUI

struct WelcomeSecondView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 80))
                    .foregroundColor(Color.accent)
                    .padding(.bottom, 36)
                
                Text("Plannings")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Create plannings and start adding transactions to them. A planning is not attached to a bank account, you can create different plannings for different purposes.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Previous")
                                .fontWeight(.semibold)
                        }
                    })
                    Spacer()
                    NavigationLink(destination: WelcomeThirdView() .navigationBarHidden(true),
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
    WelcomeSecondView()
}
