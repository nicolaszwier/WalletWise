//
//  NewTransactionView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 04/05/24.
//

import SwiftUI

struct NewTransactionView: View {
    let planningId: String
    @StateObject private var viewModel: NewTransactionViewViewModel
    @Binding var newTransactionPresented: Bool
    
    init(planningId: String, newTransactionPresented: Binding<Bool>) {
        self.planningId = planningId
        self._newTransactionPresented = newTransactionPresented
        let viewModel = NewTransactionViewViewModel(planningId: planningId)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        if $viewModel.newTransaction.type.wrappedValue == TransactionType.expense {
            Text("Add new expense")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
//                .foregroundStyle(.red)
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
                       TextField("Amount", value: $viewModel.newTransaction.amount, format: .currency(code: "CAD"))
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
                   HStack {
                       Spacer()
                       Button("Submit") {
                           Task {
                               await viewModel.submit()
                               newTransactionPresented = false
                           }
                           
                       }
                       .frame(height: 37.0)
                       .fontWeight(.heavy)
                       .frame(maxWidth: /*@START_MENU_TOKEN@*/.greatestFiniteMagnitude/*@END_MENU_TOKEN@*/)
                       .padding(.trailing)
                       .disabled(viewModel.isLoading)
                       .background(Color.blue)
                                       .foregroundColor(.white)
                       .clipShape(RoundedRectangle(cornerRadius: 8, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                       if viewModel.isLoading {
                           ProgressView()
                               .padding(.leading)
                       }
                   }
                   .padding(.top)
               }
          
           }
        }
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "plus")
            }
        }
        .navigationTitle("New")
       
        
      
    }
}

#Preview {
    NewTransactionView(planningId: "66271cf1b379cdd0d2e2f4c6", newTransactionPresented: Binding(get: {
        return true
    }, set: {_ in }))
}
