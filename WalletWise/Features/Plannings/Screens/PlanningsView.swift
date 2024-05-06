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
            VStack {
                List(viewModel.plannings) { planning in
                    NavigationLink(destination: TimelineView(planning: planning)) {
                        Text(planning.description)
                            .bold()
                    }
                }
                .padding(.top, 20)
                .listRowSpacing(12)
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.leading)
                    Spacer()
                }
                
            }
            .navigationTitle("Plannings")
            .onAppear {
                viewModel.fetchPlannings()
            }
            .toolbar {
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
}
