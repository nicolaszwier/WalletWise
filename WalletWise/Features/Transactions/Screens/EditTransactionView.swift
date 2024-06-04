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
        NavigationStack {
            if transaction.type == TransactionType.expense {
                Text("Edit expense")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding(.top)
            } else {
                Text("Edit income")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding(.top)
            }
            
            VStack {
                
                Form {
                    Section(header: Text("")) {
                        HStack() {
                            Text("Amount")
                                .multilineTextAlignment(.trailing)
                            Spacer()
                            TextField("0,00", value: $transaction.amount, format: .currency(code: Locale.current.identifier))
                                .multilineTextAlignment(.trailing)
                                .frame(width: 160)
                                .keyboardType(.decimalPad)
                                .bold()
                                .font(.title3)
                                .textFieldStyle(RoundedTextFieldStyle(icon: Image(systemName: "dollarsign"), verticalPadding: 6))
                                .onAppear(perform: {
                                    //if expense, convert the value to show as positive (logic will be handled by API)
                                    if transaction.type == TransactionType.expense &&  transaction.amount < 0 {
                                        transaction.amount = transaction.amount * -1
                                    }
                                })
                        }
                        TextField("Description", text: $transaction.description)
                            .frame(height: 35.0)
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
                        .tint(.accentColor)
                        CategoryPicker(selection: $transaction.category)
                        
                        ForEach(viewModel.formErrors, id: \.self) { error in
                            Text(error)
                                .foregroundStyle(.red)
                                .font(.callout)
                        }
                        HStack {
                            Spacer()
                            WWButton(label: "Submit", background: .accentColor) {
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
        .tint(Color.customAccent)
    }
}

#Preview {
    EditTransactionView(transaction: .constant(Transaction(id: "", periodId: "", categoryId: "", planningId: "", userId: "")), editTransactionPresented: Binding(get: {
        return true
    }, set: { _ in }))
    .environmentObject(AuthViewViewModel())
}
