//
//  PlanningItemView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import SwiftUI

struct PlanningListItemView: View {
    @EnvironmentObject var planningStore: PlanningStore
    @State private var isActive: Bool = false

    let planning: Planning
//    let viewModel: ViewModel // Replace with your actual ViewModel type
//    @State private var editingPlanning: Planning?

    var body: some View {
        Button(action: {
            planningStore.planning = planning
            isActive = true
            print("selected planning")
        }) {
            Text(planning.description)
                .multilineTextAlignment(.leading)
                .bold()
                .frame(maxWidth: .infinity)
                .frame(height: 42.0)
                .contentShape(Rectangle()) 
            Spacer()
        }
        .background(
            NavigationLink(destination: TimelineView(planning: planning), isActive: $isActive) {
                EmptyView()
            }
            .hidden()
        )
        .buttonStyle(PlainButtonStyle()) // To avoid the default button styling
//        .buttonStyle(BorderedProminentButtonStyle())
    }
}

#Preview {
    PlanningListItemView(planning: Planning(id: "123a", description: "Sample planning", currency: Currency.cad, currentBalance: 100, expectedBalance: 100, dateOfCreation: Date.now))
        .environmentObject(PlanningStore())
}
