//
//  NewTransactionView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 04/05/24.
//

import SwiftUI

struct NewTransactionView: View {
    let planning: Planning
    @StateObject private var viewModel = TransactionsViewViewModel()
    @Binding var newTransactionPresented: Bool

    var body: some View {
        if $viewModel.newTransaction.type.wrappedValue == TransactionType.expense {
            Text("Add new expense")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding(.top)
        } else {
            Text("Add new income")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
//                .foregroundStyle(.green)
                .padding(.top)
        }
       
        VStack {
            Picker(selection: $viewModel.newTransaction.type, label: Text("Transaction")) {
                Text("Expense").tag(TransactionType.expense)
                Text("Income").tag(TransactionType.income)
                }
                .pickerStyle(.segmented)
                .padding([.leading, .top, .trailing])
            
            Form {
               Section(header: Text("")) {
                   HStack() {
                       Text("Amount")
                           .multilineTextAlignment(.trailing)
                       Spacer()
                       TextField("Amount", value: $viewModel.newTransaction.amount, format: .currency(code: Locale.current.identifier))
                           .multilineTextAlignment(.trailing)
                           .frame(maxWidth: 90)
                           .keyboardType(.decimalPad)
                   }
                   TextField("Description", text: $viewModel.newTransaction.description)
               }
               Section(header: Text("")) {
                   DatePicker(
                          "Date",
                          selection: $viewModel.newTransaction.date,
                          displayedComponents: [.date]
                      )
                   Toggle(isOn: $viewModel.newTransaction.isPaid) {
                           Text("Is paid")
                   }
                   Picker("Category", selection: $viewModel.newTransaction.category) {
                       ForEach(Category.allCases, id: \.self) { option in
                           Text(option.localizedName).tag(option)
                       }
                   }
                   ForEach(viewModel.formErrors, id: \.self) { error in
                       Text(error)
                          .foregroundStyle(.red)
                          .font(.callout)
                   }
                   HStack {
                       Spacer()
                       WWButton(label: "Submit", background: Color.blue) {
                           Task {
                               await viewModel.saveNewTransaction(planningId: planning.id)
                               if viewModel.formErrors.isEmpty {
                                   newTransactionPresented = false
                               }
                           }
                       }
                       .disabled(viewModel.isLoading)
                       .padding(.trailing)
                       if viewModel.isLoading {
                           ProgressView()
                               .padding(.leading)
                       }
                   }
                   .padding(.top)
               }
               
          
           }
        }
        
      
    }
}

#Preview {
    NewTransactionView(planning: Planning(id: "", description: "", currency: Currency.cad, currentBalance:0, expectedBalance: 10, dateOfCreation: Date.now), newTransactionPresented: Binding(get: {
            return true
    }, set: { _ in }))
}

