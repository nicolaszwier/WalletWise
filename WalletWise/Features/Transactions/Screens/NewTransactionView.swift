//
//  NewTransactionView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 04/05/24.
//

import SwiftUI

struct NewTransactionView: View {
    let planning: Planning
    @EnvironmentObject var appViewModel: AppViewViewModel
    @StateObject private var viewModel = TransactionsViewViewModel()
    @Binding var newTransactionPresented: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            if $viewModel.newTransaction.type.wrappedValue == TransactionType.expense {
                Text("Add new expense")
                    .font(.headline)
                    .bold()
                    .padding(.top)
            } else {
                Text("Add new income")
                    .font(.headline)
                    .bold()
                    .padding(.top)
            }
            
            
            VStack {
                Picker(selection: $viewModel.newTransaction.type, label: Text("Transaction")) {
                    Text("Expense").tag(TransactionType.expense)
                    Text("Income").tag(TransactionType.income)
                }
                .pickerStyle(.segmented)
                .padding([.leading, .trailing])
                
                Form {
                    Section(header: Text("")) {
                        HStack() {
                            Text("Amount")
                                .multilineTextAlignment(.trailing)
                            Spacer()
                            TextField("0,00", value: $viewModel.newTransaction.amount, format: .currency(code: Locale.current.identifier))
                                .frame(width: 160)
                                .focused($isFocused)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .accessibilityIdentifier("myTextField")
                                .textFieldStyle(RoundedTextFieldStyle(icon: Image(systemName: "dollarsign"), verticalPadding: 6))
                                .font(.title2)
                                .foregroundColor($viewModel.newTransaction.type.wrappedValue == TransactionType.expense ? .red : .green)
                                .bold()
                        }
                        TextField("Description", text: $viewModel.newTransaction.description)
//                            .frame(height: 35.0)
                            
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
                        .tint(.accentColor)
                        CategoryPicker(transactionType: $viewModel.newTransaction.type, selection: $viewModel.newTransaction.category)
                        ForEach(viewModel.formErrors, id: \.self) { error in
                            Text(NSLocalizedString(error, comment: ""))
                                .foregroundStyle(.red)
                                .font(.callout)
                        }
                        HStack {
                            Spacer()
                            WWButton(isLoading: $viewModel.isLoading, label: "Submit", background: .accentColor) {
                                Task {
                                    await viewModel.saveNewTransaction(planningId: planning.id)
                                    if viewModel.formErrors.isEmpty {
                                        newTransactionPresented = false
                                    }
                                }
                            }
                            .disabled(viewModel.isLoading)
                        }
                        .padding(.top)
                    }
                    
                    
                }
                .formStyle(.grouped)
            }
            .onChange(of: viewModel.newTransaction.type) {
                if !(appViewModel.user.categories?.isEmpty ?? false) {
                    viewModel.newTransaction.category = (appViewModel.user.categories?.first(where: {$0.type == viewModel.newTransaction.type} ))!
                }
            }
            .onAppear {
                self.isFocused = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // Focus and select the text after a short delay
                    // to ensure the text field is fully focused
                    if let textField = self.getField("myTextField") as? UITextField {
                        textField.becomeFirstResponder()
                        textField.selectAll(nil)
                    }
                    
                    // selects by default the first available category for the user
                    if viewModel.newTransaction.categoryId.isEmpty && !(appViewModel.user.categories?.isEmpty ?? false) {
                        viewModel.newTransaction.category = (appViewModel.user.categories?.first(where: {$0.type == viewModel.newTransaction.type} ))!
                    }

                }
            }
        }
        .tint(Color.customAccent)
        
    }
    
    func getField(_ id: String) -> UIView? {
        let views = self_hierarchy()
        for view in views {
            for subview in view.subviews {
                if subview.accessibilityIdentifier == id {
                    return subview
                }
            }
        }
        return nil
    }
    
    func self_hierarchy() -> [UIView] {
        var views = [UIView]()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                views.append(contentsOf: window.subviews)
            }
        }
        return views
    }
}

#Preview {
    NewTransactionView(planning: Planning(id: "", description: "", currency: Currency.cad, currentBalance:0, expectedBalance: 10, dateOfCreation: Date.now), newTransactionPresented: Binding(get: {
        return true
    }, set: { _ in }))
    .environmentObject(AppViewViewModel())
}

