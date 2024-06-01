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
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
                    Button(action: {
                        Task {
                            await viewModel.update(planning: planning)
                            if viewModel.formErrors.isEmpty {
                                editPlanningPresented = false
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
    EditPlanningView(planning: .constant(Planning(id: "", description: "test", currency: Currency.cad, currentBalance: 0, expectedBalance: 0)), editPlanningPresented: .constant(true))
}
