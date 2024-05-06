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
    
    
    init() {
        self.isAuthenticated = isSignedIn()
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
                        AppService().setSignedIn(token: accessToken )
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
        return !HttpService().getToken().isEmpty;
    }
}
