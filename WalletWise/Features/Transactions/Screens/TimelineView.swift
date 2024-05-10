//
//  TimelineView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct TimelineView: View {
    let planning: Planning
    @StateObject private var viewModel = TransactionsViewViewModel()
    
//    init(planning: Planning) {
//        self.planning = planning
//        let viewModel = TransactionsViewViewModel(planningId: planning.id)
//        _viewModel = StateObject(wrappedValue: viewModel)
//    }
    
    var body: some View {
        
//        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.periods, id: \.self) { period in
                        HStack {
                            Text("\(viewModel.formattedDate(date: period.periodStart)) to \(viewModel.formattedDate(date: period.periodEnd))")
                                .accessibilityLabel("Period start date to period end date")
                                .bold()
                                .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Text(viewModel.formatCurrency(amount: period.periodBalance))
                                .accessibilityLabel("Balance: \(viewModel.formatCurrency(amount: period.periodBalance))")
                                .bold()
                                .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.horizontal)
                        
                        GroupBox() {
                            ForEach(period.transactions) { transaction in
                                TransactionsListItemView(transaction: transaction)
                            }
                            Divider()
                                .padding(.top, 5)
                            HStack {
                               Text("Expected balance on \(viewModel.formattedDate(date: period.periodEnd))")
                                    .accessibilityLabel("Expected balance on \(period.periodEnd)")
                                   .foregroundColor(.secondary)
                                   .font(.footnote)
                                   .padding(.leading)
                               Spacer()
                               Text(viewModel.formatCurrency(amount: period.expectedAllTimeBalance))
                                   .accessibilityLabel("Period balance: \(viewModel.formatCurrency(amount: period.periodBalance))")
                                   .font(.title3)
                                   .bold()
                                   .foregroundColor(Color.green)
                           }
                        }
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.leading)
                        Spacer()
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbar {
                    Button {
                        viewModel.isPresentingFiltersView = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    Button {
                        viewModel.isPresentingNewTransactionView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .navigationTitle(planning.description)
                .sheet(isPresented: $viewModel.isPresentingNewTransactionView, onDismiss: didDismiss){
                    
                    NavigationStack {
                        NewTransactionView(planning: planning, newTransactionPresented: $viewModel.isPresentingNewTransactionView)
                           .toolbar {
                               ToolbarItem(placement: .cancellationAction) {
                                   Button("Cancel") {
                                       viewModel.isPresentingNewTransactionView = false
                                   }
                               }
                               ToolbarItem(placement: .confirmationAction) {
                               }
                           }
                    }
    
                }
                .sheet(isPresented: $viewModel.isPresentingFiltersView) {
                    FiltersView()
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetch(planning: planning)
                }
            }
        
    }
    
    func didDismiss() {
        Task {
            await viewModel.fetch(planning: planning)
        }
    }
}

#Preview {
    TimelineView(planning: Planning(id: "66271cf1b379cdd0d2e2f4c6", description: "Sample planning name bem grndao", currency: Currency.cad, initialBalance: 100, dateOfCreation: Date.now))
}
