//
//  PlanningsView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct PlanningsView: View {
    @StateObject var viewModel = PlanningsViewViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.plannings) { planning in
                NavigationLink(destination: TimelineView(planning: planning)) {
                    Text(planning.description)
                        .bold()
                        .padding()
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                
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
                    
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        
    }
}

#Preview {
    PlanningsView()
        .environmentObject(AuthViewViewModel())
}
