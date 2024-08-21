//
//  WelcomeFourthView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 13/08/24.
//

import SwiftUI

struct WelcomeFourthView: View {
    @AppStorage(Constants.UserDefaults.welcomeScreenDone) var isWelcomeScreenDone = false
    @Environment(\.dismiss) var dismiss
    @State var isPressed: Bool = false
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "checkmark.square")
                    .font(.system(size: 80))
                    .foregroundColor(Color.accent)
                    .padding(.bottom, 36)
                
                Text("You’re all set!")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                
                Text("Let’s start creating your first planning. ")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                Spacer()
                NavigationLink(destination: MainView().navigationBarHidden(true),
                               isActive: $isPressed) { EmptyView() }
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
                    Button(action: {
                        isPressed = true
                        isWelcomeScreenDone = true
                    }, label: {
                        HStack(spacing: 8) {
                            Text("Create first planning")
                                .fontWeight(.semibold)
                        }
                    })
                    .buttonStyle(BorderedButtonStyle())
                }
                .padding(.horizontal)
                
            }
            .padding(.all)
        }
    }
}

#Preview {
    WelcomeFourthView()
        .environmentObject(PlanningStore())
}
