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
                    .tint(.primary)
                    ForEach(viewModel.formErrors, id: \.self) { error in
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.callout)
                    }
                    WWButton(isLoading: $viewModel.isLoading, label: "Submit", background: .accentColor) {
                        Task {
                            await viewModel.save()
                            if viewModel.formErrors.isEmpty {
                                newPlanningPresented = false
                            }
                        }
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.top)
                }
            }
        }
        .tint(Color.customAccent)
    }
}

#Preview {
    NewPlanningView(newPlanningPresented: .constant(true))
}
