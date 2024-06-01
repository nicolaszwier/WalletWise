//
//  NewPlanningView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct NewPlanningView: View {
    @StateObject private var viewModel = PlanningsViewViewModel()
    @Binding var newPlanningPresented: Bool
    
    var body: some View {
        Text("Add new planning")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .bold()
            .padding(.top)
        
        VStack {
            Form {
                Section(header: Text("")) {
                    TextField("Description", text: $viewModel.newPlanning.description)
                        .frame(height: 35.0)
                    Picker(selection: $viewModel.newPlanning.currency, label: Text("Currency")) {
                        Text("Canadian Dollars (CA$)").tag(Currency.cad)
                        Text("Brazilian Real (R$)").tag(Currency.brl)
                    }
                    ForEach(viewModel.formErrors, id: \.self) { error in
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.callout)
                    }
                    Button(action: {
                        Task {
                            await viewModel.save()
                            if viewModel.formErrors.isEmpty {
                                newPlanningPresented = false
                            }
                        }
                    }, label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Submit")
                        }
                    })
                    .frame(height: 42.0)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .greatestFiniteMagnitude)
                    .disabled(viewModel.isLoading)
                    .background(viewModel.isLoading ? Color.secondary : .accent)
                                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    NewPlanningView(newPlanningPresented: .constant(true))
}
