//
//  ProfileScreen.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AppViewViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                IconRoundedRectangleView(icon: "person.fill", circleColor: Color(UIColor.secondarySystemFill), imageColor: .primary, frameSize: 46)
                    .padding(.top, 60)
                Text(viewModel.user.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding(.top)
                Text(viewModel.user.email)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Signout") {
                    viewModel.signout()
                }
                .padding()
                .fontWeight(.heavy)
            }
            .navigationTitle("My profile")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppViewViewModel())
}
