//
//  ContentView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = AppViewViewModel()
    @StateObject private var planningStore = PlanningStore()
    
    var body: some View {
        VStack {
            if viewModel.isAuthenticated {
                TabView {
                    DashboardView()
                        .environmentObject(planningStore)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.circle.fill")
                        }
                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .trailing))
            } else {
                SigninView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .leading))
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    MainView()
        .environmentObject(TransactionsViewViewModel())
}
