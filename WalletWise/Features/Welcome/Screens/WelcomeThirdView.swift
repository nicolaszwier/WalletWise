//
//  WelcomeThirdView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 13/08/24.
//

import SwiftUI

struct WelcomeThirdView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "calendar.badge.checkmark")
                    .font(.system(size: 80))
                    .foregroundColor(Color.accent)
                    .padding(.bottom, 36)
                
                Text("Periods and transactions")
                    .font(.title2)
                    .fontWeight(.semibold)
                                
                Text("The app automatically creates the weekly periods for you based on your transactions! All you need to do is start adding expenses and incomes. ")
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
                    NavigationLink(destination: WelcomeFourthView() .navigationBarHidden(true),
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
    }
}

#Preview {
    WelcomeThirdView()
}
