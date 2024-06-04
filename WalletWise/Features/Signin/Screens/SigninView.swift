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
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                        .font(.callout)
                }
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "person.circle")))
                
                SecureField("Password", text: $viewModel.password)
                    .padding(.bottom)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "lock")))
                
                Form {
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
                    .buttonStyle(BorderedButtonStyle())
                    .frame(height: 42.0)
                    .fontWeight(.heavy)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.greatestFiniteMagnitude/*@END_MENU_TOKEN@*/)
                    .disabled(viewModel.isLoading)
                    .background(viewModel.isLoading ? Color.secondary : .accent)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                }
                .formStyle(.columns)

            
                VStack {
                    Text("Doesn't have an account?")
                        .foregroundStyle(.secondary)
                    NavigationLink("Create one", destination: SignupView())
                        .bold()
                        .foregroundColor(.accentColor)
                        
                }
                .padding(.vertical)
             
            }
            .padding(30)
        }
    }
}

#Preview {
    SigninView()
}
