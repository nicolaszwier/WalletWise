//
//  SigninViewViewModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation
import SwiftUI

class AuthViewViewModel: ObservableObject {
    @Published var email = "new@email.com"
    @Published var password = "12345678"
    @Published var errorMessage = ""
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var user: User = User(name: "", email: "", categories: [])
//    User(name: "Nicolas", email: "new@email.com", categories: [
//        Category(id: "66554169fabcc70f1a97b0c7", description: "Default", icon: "ellipsis.circle.fill", userId: "6626d12364ea04466897d9d5", active: true),
//        Category(id: "sgdgd2423", description: "Shopping", icon: "basket.fill", userId: "", active: true),
//        Category(id: "wf2", description: "Transportation", icon: "bus", userId: "", active: true),
//        Category(id: "6622be18761e0a4a18079361", description: "Groceries", icon: "cart.fill", userId: "6626d12364ea04466897d9d5", active: true),
//        Category(id: "sdv34f", description: "Income", icon: "dollarsign.circle.fill", userId: "", active: true),
//        Category(id: "34hh2", description: "Home", icon: "house.fill", userId: "", active: true),
//        Category(id: "34f4", description: "Dining", icon: "fork.knife", userId: "", active: true),
//    ])
//    @EnvironmentObject var appStore: AppStore
    
    
    init() {
        self.isAuthenticated = isSignedIn()
        
        Task {
            if isSignedIn() {
                await fetchUser()
            }
        }
        
    }
    
    func fetchUser() async {
        await MainActor.run {
            self.isLoading = true;
        }
        do {
            let response = try await UserModel().fetch()
            
            await MainActor.run {
                withAnimation(){
                    self.user = response
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                print("Error fetching data: \(error)")
                self.isLoading = false;
            }
        }
        
    }
    
    func signIn() async  {
        self.isLoading = true;
        do {
            let response = try await SigninModel().signin(email: email, password: password)
            if let accessToken = response.accessToken {
                DispatchQueue.main.async {
                    withAnimation(){
                        print("success")
                        self.isLoading = false;
                        self.isAuthenticated = true;
                        AppStore.shared.setToken(value: accessToken)
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("Error fetching data: \(error)")
                self.isLoading = false;
                self.errorMessage = "Invalid email or password"
            }
        }
    }
    
    func signout()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isAuthenticated = false;
            AppService().signout()
        }
    }
    
    private func isSignedIn() -> Bool {
        return !AppStore.shared.getToken().isEmpty;
    }
}
