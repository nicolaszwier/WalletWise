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
    @AppStorage(Constants.UserDefaults.welcomeScreenDone) var isWelcomeScreenDone = false
    @State var checkIsWelcomeScreenDone: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.isAuthenticated {
                if checkIsWelcomeScreenDone {
                    TabView {
                        DashboardView()
                            .environmentObject(planningStore)
                            .tabItem {
                                Label("Dashboard", systemImage: "house")
                            }
                        ProfileView()
                            .tabItem {
                                Label("Profile", systemImage: "person.circle.fill")
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .trailing))
                } else {
                    WelcomeFirstView()
                }
            } else {
                SigninView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .leading))
            }
        }
        .onAppear {
//            isWelcomeScreenDone = false
            checkIsWelcomeScreenDone = isWelcomeScreenDone
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    MainView()
        .environmentObject(TransactionsViewViewModel())
        .environmentObject(PlanningStore())
}
