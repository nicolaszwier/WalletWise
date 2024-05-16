//
//  EditTransactionView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 11/05/24.
//

import SwiftUI

struct EditTransactionView: View {
    @Binding var transaction: Transaction
    @StateObject private var viewModel = TransactionsViewViewModel()
    @Binding var editTransactionPresented: Bool

    var body: some View {
        if transaction.type == TransactionType.expense {
            Text("Edit expense")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding(.top)
        } else {
            Text("Edit income")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
//                .foregroundStyle(.green)
                .padding(.top)
        }
       
        VStack {
            
            Form {
               Section(header: Text("")) {
                   HStack() {
                       Text("Amount")
                           .multilineTextAlignment(.trailing)
                       Spacer()
                       TextField("Amount", value: $transaction.amount, format: .currency(code: Locale.current.identifier))
                           .multilineTextAlignment(.trailing)
                           .frame(maxWidth: 90)
                           .keyboardType(.decimalPad)
                           .onAppear(perform: {
                               //if expense, convert the value to show as positive (logic will be handled by API)
                               if transaction.type == TransactionType.expense {
                                   transaction.amount = transaction.amount * -1
                               }
                           })
                   }
                   TextField("Description", text: $transaction.description)
               }
               Section(header: Text("")) {
                   DatePicker(
                          "Date",
                          selection: $transaction.date,
                          displayedComponents: [.date]
                      )
                   Toggle(isOn: $transaction.isPaid) {
                           Text("Is paid")
                   }
                   Picker("Category", selection: $transaction.category) {
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
                               await viewModel.updateTransaction(transaction: transaction)
                               if viewModel.formErrors.isEmpty {
                                   editTransactionPresented = false
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
    EditTransactionView(transaction: .constant(Transaction(id: "", periodId: "", planningId: "", userId: "")), editTransactionPresented: Binding(get: {
        return true
}, set: { _ in }))
}
