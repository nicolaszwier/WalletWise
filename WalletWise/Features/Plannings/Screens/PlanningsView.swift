//
//  PlanningsView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct PlanningsView: View {
    @StateObject var viewModel = PlanningsViewViewModel()
    @State private var editingPlanning = Planning(id: "", description: "", currency: Currency.brl, currentBalance: 0, expectedBalance: 0)
    
    var body: some View {
        NavigationView {
            List(viewModel.plannings) { planning in
                NavigationLink(destination: TimelineView(planning: planning)) {
                    Text(planning.description)
                        .bold()
                        .padding()
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.remove(planningId: planning.id )
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                editingPlanning = planning
                                viewModel.isPresentingEditPlanningView = true
                            } label: {
                                Label("Flag", systemImage: "pencil.circle")
                            }
                            .tint(.blue)
                        }
                }
            }
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
            
            if $viewModel.plannings.isEmpty && !viewModel.isLoading {
                Text("We couldn’t find any plannings, go ahead and create the first one")
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .foregroundColor(.secondary)
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
        .environmentObject(AuthViewViewModel())
}
