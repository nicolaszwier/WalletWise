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
    
    var body: some View {
        
        
        Group {
            TimelineTotalsViews(expectedBalance: $viewModel.planningExpectedBalance, currentBalance: $viewModel.planningCurrentBalance)
            
            if $viewModel.periods.isEmpty && !viewModel.isLoading {
                Text("We couldn’t find any transactions, go ahead and register the first one")
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .foregroundColor(.secondary)
            }
            List {
                ForEach($viewModel.periods, id: \.self) { $period in
                    if !period.transactions.isEmpty {
                        Section {
                            ForEach(period.transactions.indices, id: \.self) { index in
                                TransactionsListItemView(transaction: $period.transactions[index], refreshTrigger: {
                                    await viewModel.fetch(planning: planning)
                                }, onEditDismiss: didDismiss)
                            }
                        } header: {
                            PeriodHeader(period: period)
                        } footer: {
                            PeriodFooter(period: $period)
                                .padding(.bottom)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            //        .listRowSpacing(6)
            .refreshable { await viewModel.fetch(planning: planning) }
            .task {
                await viewModel.fetch(planning: planning)
            }
            .frame(maxHeight: .infinity)
            .toolbar {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.leading)
                        .zIndex(2)
                }
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
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.isPresentingNewTransactionView, onDismiss: didDismiss){
                NavigationStack {
                    NewTransactionView(planning: planning, newTransactionPresented: $viewModel.isPresentingNewTransactionView)
                }
                
            }
            .sheet(isPresented: $viewModel.isPresentingFiltersView) {
                FiltersView(planning: planning, filtersViewPresented: $viewModel.isPresentingFiltersView)
            }
        }
        .environmentObject(viewModel)
    }
    
    
    func didDismiss() {
        Task {
            await viewModel.fetch(planning: planning)
        }
    }
}

#Preview {
    TimelineView(planning: Planning(id: "66410a4bbe0ab6de43a126b5", description: "Sample planning name bem grndao", currency: Currency.cad, currentBalance: 100, expectedBalance: 100, dateOfCreation: Date.now))
}
