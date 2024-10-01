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
    @EnvironmentObject var planningStore: PlanningStore
    @State private var totalSelected: Decimal = 0
    
    var isSearching: Bool {
        return !viewModel.searchQuery.isEmpty
     }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            if $viewModel.periods.isEmpty && !viewModel.isLoading {
                Text("We couldn’t find any transactions, go ahead and register the first one")
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .foregroundColor(.secondary)
            }
            List {
                if !isSearching {            
                    TimelineTotalsView(expectedBalance: $viewModel.planningExpectedBalance, currentBalance: $viewModel.planningCurrentBalance)
                        .listRowBackground(Constants.UI.defaultGradient)
                }
                ForEach(isSearching ? $viewModel.localSearchResults : $viewModel.periods, id: \.self) { $period in
                    if !period.transactions.isEmpty {
                        Section {
                            ForEach(period.transactions.indices, id: \.self) { index in
                                let transaction = period.transactions[index]
                                TransactionsListItemView(transaction: $period.transactions[index], isSelected: viewModel.selectedTransactions.contains(transaction), toggleSelection: {
                                    if viewModel.selectedTransactions.contains(transaction) {
                                        viewModel.selectedTransactions.remove(transaction)
                                    } else {
                                        viewModel.selectedTransactions.insert(transaction)
                                    }
                                    withAnimation {
                                        if !viewModel.selectedTransactions.isEmpty {
                                            viewModel.isSelectionMode = true
                                        } else {
                                            viewModel.isSelectionMode = false
                                        }
                                    }
                                }, refreshTrigger: {
                                    await viewModel.fetch(planning: planning)
                                }, onEditDismiss: didDismiss, allowSelection: true, allowSwipeActions: true)
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
            .searchable(
                text: $viewModel.searchQuery,
                placement: .automatic,
                prompt: "Search transactions"
            )
            .overlay {
                if isSearching && viewModel.localSearchResults.isEmpty {
                    ContentUnavailableView(
                        "Transaction not found",
                        systemImage: "magnifyingglass",
                        description: Text("No results for \(viewModel.searchQuery)")
                    )
                }
            }
            .textInputAutocapitalization(.never)
            .listStyle(.insetGrouped)
            .refreshable { await viewModel.fetch(planning: planning) }
            .task {
                await viewModel.fetch(planning: planning)
            }
            .onChange(of: viewModel.searchQuery) {
                viewModel.localSearchResults = viewModel.filterTransactions(by: viewModel.searchQuery)
            }
            .onChange(of: viewModel.planningExpectedBalance) { oldValue, newValue in
                planningStore.expectedBalanceBinding.wrappedValue = newValue
            }
            .onChange(of: viewModel.planningCurrentBalance) { oldValue, newValue in
                planningStore.currentBalanceBinding.wrappedValue = newValue
            }
            .onChange(of: viewModel.selectedTransactions) { oldValue, newValue in
                totalSelected = viewModel.selectedTransactions.reduce(0) {
                    $0 + ($1.amount ?? 0)
                }
            }
            .frame(maxHeight: .infinity)
            .toolbar {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.leading)
                        .zIndex(2)
                }
                if (viewModel.isSelectionMode) {
                    Button {
                        viewModel.selectedTransactions.removeAll()
                        viewModel.isSelectionMode = false
                    } label: {
                        Text("Cancel")
                    }
                } else {
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
            .sheet(isPresented: $viewModel.isPresentingDuplicateTransactionsView, onDismiss: didDismiss) {
                DuplicateTransactionsView(transactions: Array(viewModel.selectedTransactions), duplicateTransactionPresented: $viewModel.isPresentingDuplicateTransactionsView)
            }
            
            if (viewModel.isSelectionMode) {
                VStack {
                    HStack(alignment: .center) {
                        Text("\(viewModel.selectedTransactions.count) transaction\(viewModel.selectedTransactions.count > 1 ? "s" : "") selected")
                            .contentTransition(.numericText())
                            .transaction { t in
                                t.animation = .smooth
                            }
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                        Spacer()
                        Text(totalSelected.formatted(.currency(code: planningStore.planning?.currency.rawValue ?? "BRL")))
                            .contentTransition(.numericText())
                            .transaction { t in
                                t.animation = .smooth
                            }
                            .foregroundStyle(.accent)
                            .bold()
                            .font(.title2)
                    }
                    .padding()
                    
                    WWButton(isLoading: .constant(false), label: "Duplicate", background: .accentColor) {
                        viewModel.isPresentingDuplicateTransactionsView = true
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.accentColor)
                        
                    )
                    .padding([.horizontal, .bottom])
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .padding(20)
                .transition(.move(edge: .bottom))
                .tint(Color.customAccent)
                .shadow(radius: 6, x: 0, y: 8)
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
    TimelineView(planning: Planning(id: "6680c1ae817a7ffd7d648e27", description: "Sample planning name bem grndao", currency: Currency.cad, currentBalance: 100, expectedBalance: 100, dateOfCreation: Date.now))
        .environmentObject(PlanningStore())
        .environmentObject(AppViewViewModel())
}
