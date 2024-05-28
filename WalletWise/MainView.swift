//
//  ContentView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = AuthViewViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isAuthenticated {
                TabView {
                    PlanningsView()
                        .tabItem {
                            Label("Plannings", systemImage: "dollarsign.circle.fill")
                        }
                    ProfileView(viewModel: viewModel)
                        .tabItem {
                            Label("Profile", systemImage: "person.circle.fill")
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .trailing))
            } else {
                SigninView(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .leading))
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    MainView()
}
