//
//  PlanningsView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct PlanningsView: View {
    @StateObject var viewModel = PlanningsViewViewModel()
    @EnvironmentObject var planningStore: PlanningStore
    @State private var editingPlanning = Planning(id: "", description: "", currency: Currency.brl, currentBalance: 0, expectedBalance: 0)
    
    var body: some View {
        NavigationView {
            List(viewModel.plannings) { planning in
                PlanningListItemView(planning: planning)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.remove(planningId: planning.id )
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                        Button {
                            editingPlanning = planning
                            viewModel.isPresentingEditPlanningView = true
                        } label: {
                            Label("Flag", systemImage: "pencil.circle")
                        }
                        .tint(.blue)
                    }
             
            }
            .listStyle(DefaultListStyle())
            .listRowSpacing(12)
            .refreshable {  await viewModel.fetch() }
            .navigationTitle("Plannings")
            .task {
                await viewModel.fetch()
            }
            .toolbar {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.leading)
                        .zIndex(2)
                    Spacer()
                }
                Button {
                    viewModel.isPresentingNewPlannningView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.isPresentingNewPlannningView, onDismiss: didDismiss){
                NavigationStack {
                    NewPlanningView(newPlanningPresented: $viewModel.isPresentingNewPlannningView)
                }
            }
            .sheet(isPresented: $viewModel.isPresentingEditPlanningView, onDismiss: didDismiss){
                NavigationStack {
                    EditPlanningView(planning: $editingPlanning, editPlanningPresented: $viewModel.isPresentingEditPlanningView)
                }
            }
            
        }
        .tint(.primary)
      
    }
    
    func didDismiss() {
        Task {
            await viewModel.fetch()
        }
    }
}

#Preview {
    PlanningsView()
        .environmentObject(AppViewViewModel())
        .environmentObject(PlanningStore())
}
