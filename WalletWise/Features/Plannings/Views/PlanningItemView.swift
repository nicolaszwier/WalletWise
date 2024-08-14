//
//  PlanningItemView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import SwiftUI

struct PlanningListItemView: View {
    let planning: Planning
    @Binding var selectePlanningSheetPresented: Bool
    @EnvironmentObject var planningStore: PlanningStore
//    @State private var isActive: Bool = false

    var body: some View {
        Button(action: {
            planningStore.setSelectedPlanning(planning: planning)
            selectePlanningSheetPresented = false
//            isActive = true
        }) {
            VStack {
                HStack {
                    Text(planning.description)
                        .bold()
                        .padding(.horizontal)
                    Spacer()
                    Text(planning.currency.rawValue)
                        .font(.caption2)
                        .padding(.horizontal)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 42.0)
            .contentShape(Rectangle())
//            .background(.gray)
          
            
        }
//        .background(
//            NavigationLink(destination: TimelineView(planning: planning), isActive: $isActive) {
//                EmptyView()
//            }
//            .hidden()
//        )
        .buttonStyle(PlainButtonStyle()) // To avoid the default button styling
//        .buttonStyle(BorderedProminentButtonStyle())
    }
}

#Preview {
    PlanningListItemView(planning: Planning(id: "123a", description: "Sample planning", currency: Currency.cad, currentBalance: 100, expectedBalance: 100, dateOfCreation: Date.now), selectePlanningSheetPresented: .constant(true))
        .environmentObject(PlanningStore())
}
