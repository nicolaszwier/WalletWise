//
//  SigninView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct SigninView: View {
    @StateObject var viewModel = AuthViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack() {
                Text("WalletWise")
                    .font(.title)
                    .bold()
                    .padding(.top)
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                            .font(.callout)
                    }
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        
                    SecureField("Password", text: $viewModel.password)
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                await viewModel.signIn()
                            }
                        }, label: {
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Text("Signin")
                            }
                        })
                        .frame(height: 42.0)
                        .fontWeight(.heavy)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.greatestFiniteMagnitude/*@END_MENU_TOKEN@*/)
                        .padding(.trailing)
                        .disabled(viewModel.isLoading)
                        .background(viewModel.isLoading ? Color.secondary : .accent)
                                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    }
                }
            
                VStack {
                    Text("Doesn't have an account?")
                    NavigationLink("Create one", destination: SignupView())
                        .bold()
                        
                }
                .padding(.bottom)
             
            }
        }
    }
}

#Preview {
    SigninView()
}
