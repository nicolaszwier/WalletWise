//
//  ProfileScreen.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.user.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding(.top, 60)
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
//            .toolbar {
//                Button {
//                    
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewViewModel())
}
