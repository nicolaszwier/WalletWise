//
//  DashboardView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 01/08/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var planningStore: PlanningStore
    @StateObject private var viewModel = DashboardViewViewModel()
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack (alignment: .center) {
                    PlanningSelectorView()
                        .padding(.top, 60)
                    DashboardTotalsView(
                        expectedBalance: planningStore.expectedBalanceBinding,
                        currentBalance: planningStore.currentBalanceBinding
                    )
                    .padding([.top], 15)
                    .padding([.horizontal], 25)
                    NavigationLink(destination: TimelineView(planning: planningStore.planning ?? planningStore.emptyPlanning), label: {
                        
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "dollarsign.circle")
                                .foregroundStyle(.primary)
                                .padding()
                            Text("Transactions timeline")
                                .frame(maxWidth: .infinity)
                                .frame(height: 32.0)
                                .bold()
                                .foregroundStyle(.primary)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.primary)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 42.0)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(UIColor.secondarySystemBackground))
                        )
                    })
                    .padding()
                    .padding(.bottom, 100)
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .frame(maxWidth: .greatestFiniteMagnitude)
                .background(Constants.UI.defaultGradient)
                VStack(alignment: .center) {
                    if !viewModel.isLoading {
                        DashboardExpiringTransactionsSection(transactions: $viewModel.expiringTransactions)
                    } else {
                        ProgressView()
                            .padding()
                            .zIndex(2)
                    }
                    Spacer()
                }
                .offset(y: -120)
                .padding()
            }
            .ignoresSafeArea(.all, edges: .top)
            .task {
                await viewModel.fetchExpiringTransactions(planningId: planningStore.planning?.id ?? "")
            }
            .onChange(of: planningStore.planning?.id) { oldValue, newValue in
                Task {
                    await viewModel.fetchExpiringTransactions(planningId: newValue ?? "")
                }
            }
            .environmentObject(viewModel)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .refreshable {
            await viewModel.fetchExpiringTransactions(planningId: planningStore.planning?.id ?? "")
        }
    }
    
}

#Preview {
    DashboardView()
        .environmentObject(PlanningStore())
        .environmentObject(TransactionsViewViewModel())
        .environmentObject(AppViewViewModel())
}
