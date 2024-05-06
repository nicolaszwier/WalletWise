//
//  SigninViewViewModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation

class AuthViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isAuthenticated: Bool = false
    
    
    init() {
        self.isAuthenticated = isSignedIn()
    }
    
    func signIn()  {
        SigninModel().signin(email: email, password: password) { result in
            switch result {
                case .success(let token):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        print("success")
                        self.isAuthenticated = true;
                        AppService().setSignedIn(token: token)
                    }
                  
                case .failure(_):
                    self.errorMessage = "Invalid email or password"
               
            }
        }
    }
    
    private func isSignedIn() -> Bool {
        return !HttpService().getToken().isEmpty;
    }
}
