//
//  SignupView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var viewModel: AppViewViewModel
    @Environment(\.presentationMode) var presentationMode
    
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
                .padding(.bottom, 30)
                
                Text("Create account")
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
               
                TextField("Name", text: $viewModel.newUser.name)
                    .keyboardType(.namePhonePad)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "person.circle")))
                
                TextField("Email", text: $viewModel.newUser.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "envelope")))
                
                SecureField("Password", text: $viewModel.newUser.password)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "lock")))
                
                SecureField("Confirm password", text: $viewModel.newUser.passwordConfirmation)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "lock")))

                ForEach(viewModel.formErrors, id: \.self) { error in
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.callout)
                        .padding(.top)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Form {
                    Button(action: {
                        Task {
                            await viewModel.signUp()
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 32.0)
                        } else {
                            Text("Signup")
                                .frame(maxWidth: .infinity)
                                .frame(height: 32.0)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .disabled(viewModel.isLoading)
                    .padding(.top)
                }
                .formStyle(.columns)

                VStack {
                    Text("Already have an account?")
                        .foregroundStyle(.secondary)
                    Button(action:{ self.presentationMode.wrappedValue.dismiss() }){
                        Text("Signin instead")
                            .font(.callout)
                            .bold()
                            .foregroundColor(.accentColor)
                    }
                    
                }
                .padding(.vertical)
            }
            .padding(30)
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    SignupView()
        .environmentObject(AppViewViewModel())
}
