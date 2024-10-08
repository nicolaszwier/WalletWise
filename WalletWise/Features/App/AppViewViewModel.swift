//
//  SigninViewViewModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import Foundation
import SwiftUI

class AppViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var user: User = User(name: "", email: "", categories: [])
    @Published var newUser = SignupRequest(name: "", email: "", password: "", passwordConfirmation: "")
    @Published var formErrors: [String] = []
    
    init() {
        self.isAuthenticated = isSignedIn()
        
        Task {
            if isSignedIn() {
                await fetchUser()
            }
        }
        
    }
    
    func fetchUser() async {
        self.loader(show: true)
        do {
            let response = try await UserModel().fetch()
            
            await MainActor.run {
                withAnimation(){
                    self.user = response
                    self.loader(show: false)
                }
            }
        } catch {
            await MainActor.run {
                self.loader(show: false)
                switch error {
                case AuthenticationError.unauthorized:
                    self.errorMessage = "Invalid email or password"
                default:
                    print("Error fetching data: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    func signIn() async  {
        guard isSigninFormValid(email: self.email, password: self.password) else {
            return
        }
        self.loader(show: true)
        do {
            let response = try await SigninModel().signin(email: email, password: password)
            if let accessToken = response.accessToken {
                DispatchQueue.main.async {
                    withAnimation(){
                        print("success")
                        self.loader(show: false)
                        self.isAuthenticated = true;
                        self.email = ""
                        self.password = ""
                        AppStore.shared.setToken(value: accessToken)
                    }
                }
            }
            await fetchUser()
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
                self.loader(show: false)
                switch error {
                case AuthenticationError.unauthorized:
                    self.errorMessage = "Invalid email or password"
                case NetworkError.badRequest:
                    self.errorMessage = "An error occurred while trying to signin"
                default:
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signUp() async  {
        guard isSignupFormValid(user: self.newUser) else {
            return
        }
        self.loader(show: true)
        do {
            let response = try await SignupModel().signup(data: self.newUser)
            if let accessToken = response.accessToken {
                DispatchQueue.main.async {
                    withAnimation(){
                        AppStore.shared.setWelcomeScreenDone(value: false)
                        print("success")
                        self.loader(show: false)
                        self.isAuthenticated = true;
                        AppStore.shared.setToken(value: accessToken)
                    }
                }
            }
            await fetchUser()
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
                self.loader(show: false)
                switch error {
                case AuthenticationError.emailTaken:
                    self.formErrors.append("This email is already being used")
                default:
                    self.formErrors.append(error.localizedDescription)
                }
            }
        }
    }
    
    private func isSignupFormValid(user: SignupRequest) -> Bool {
        self.formErrors.removeAll()
        
        guard !user.name.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.formErrors.append("Name should not be empty.")
            return false
        }
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           
        guard emailPredicate.evaluate(with: user.email) else {
            self.formErrors.append("Please inform a valid email")
            return false
        }
        
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
           
        guard passwordPredicate.evaluate(with: user.password) else {
            self.formErrors.append("Your password should be at least 8 characters long and contain: at least one letter, one digit and one especial character")
            return false
        }
        
        guard user.password == user.passwordConfirmation else {
            self.formErrors.append("Password and password confirmation doesn't match")
            return false
        }
        
        return true
    }
    
    private func isSigninFormValid(email: String, password: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           
        guard emailPredicate.evaluate(with: email) else {
            self.errorMessage = "Please inform a valid email"
            return false
        }
        
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
           
        guard passwordPredicate.evaluate(with: password) else {
            self.errorMessage = "Your password should be at least 8 characters long and contain: at least one letter, one digit and one especial character"
            return false
        }
        
        return true
    }
    
    
    func signout()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isAuthenticated = false;
            self.user = User(name: "", email: "", categories: nil)
            AppService().signout()
        }
    }
    
    private func isSignedIn() -> Bool {
        return !AppStore.shared.getToken().isEmpty;
    }
    
    private func loader(show: Bool) {
        DispatchQueue.main.async {
            self.isLoading = show;
        }
    }
}
