//
//  EditPlanningView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/05/24.
//

import SwiftUI

struct EditPlanningView: View {
    @Binding var planning: Planning
    @StateObject private var viewModel = PlanningsViewViewModel()
    @Binding var editPlanningPresented: Bool
    var body: some View {
        Text("Edit planning")
            .font(.headline)
            .bold()
            .padding(.top)
        
        VStack {
            Form {
                Section(header: Text("")) {
                    TextField("Description", text: $planning.description)
                        .frame(height: 35.0)
                    
                    HStack {
                        Label("Currency:", systemImage: "dollarsign.circle")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(planning.currency.rawValue)
                            .foregroundStyle(.secondary)
                    }
                    ForEach(viewModel.formErrors, id: \.self) { error in
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.callout)
                    }
                    WWButton(isLoading: $viewModel.isLoading, label: "Submit", background: .accentColor) {
                        Task {
                            await viewModel.update(planning: planning)
                            if viewModel.formErrors.isEmpty {
                                editPlanningPresented = false
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
    EditPlanningView(planning: .constant(Planning(id: "", description: "test", currency: Currency.cad, currentBalance: 0, expectedBalance: 0)), editPlanningPresented: .constant(true))
}
