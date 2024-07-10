//
//  SigninView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct SigninView: View {
    @EnvironmentObject var viewModel: AppViewViewModel
    @State var showSignupView = false
    
    var body: some View {
        NavigationStack {
            VStack() {
                HStack(alignment: .center) {
                    Image("AppIcon-WW")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 40)
                    
                    Text("WalletWise")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    //                        .bold()
                }
                .padding(.bottom, 40)
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "person.circle")))
                
                SecureField("Password", text: $viewModel.password)
                    .padding(.bottom)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "lock")))
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                        .font(.callout)
                        .padding(.bottom)
                }
                
                Form {
                    Button(action: {
                        Task {
                            await viewModel.signIn()
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 32.0)
                        } else {
                            Text("Signin")
                                .frame(maxWidth: .infinity)
                                .frame(height: 32.0)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .disabled(viewModel.isLoading)
                }
                .formStyle(.columns)
            
                VStack {
                    
                        Text("Doesn't have an account?")
                            .foregroundStyle(.secondary)
                           
                        Button("Create one") {
                            showSignupView = true
                            //                        .foregroundColor(.accentColor)
                        }
                        .bold()
                    
//                    NavigationStack {
//                        navigationDestination(isPresented: $showSignupView) {
//                            SignupView()
//                        }
//                    }
//                    NavigationLink("Create one", destination: SignupView(), isActive: $showSignupView)
//                        .bold()
//                        .foregroundColor(.accentColor)
                        
                }
                .navigationDestination(isPresented: $showSignupView) {
                    SignupView()
                }
                .padding(.vertical)
             
            }
            .padding(30)
        }
    }
}

#Preview {
    SigninView()
        .environmentObject(AppViewViewModel())
}
