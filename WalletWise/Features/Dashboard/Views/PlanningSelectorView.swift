//
//  PlanningSelectorView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 01/08/24.
//

import SwiftUI

struct PlanningSelectorView: View {
    @State private var isPressed = false
    @State private var isPresentingSheet = false
    @EnvironmentObject var planningStore: PlanningStore
    var body: some View {
        Button(action: {
            isPressed.toggle()
            isPresentingSheet = true
        }) {
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                Text(planningStore.planning?.description ?? "Select planning")
                    .padding(.trailing, 10)
                    .frame(height: 32.0)
                    .bold()
                
                Image(systemName: "chevron.down")
            }
            .padding(.horizontal, 20)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(20)
            
            
        }
        .sensoryFeedback(.start, trigger: isPressed)
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isPresentingSheet){
            NavigationStack {
                PlanningsView(selectePlanningSheetPresented: $isPresentingSheet)
            }
        }
        .onAppear {
            if (planningStore.getSelectedPlanning() == nil) {
                isPresentingSheet = true
            }
        }
    }
}

#Preview {
    PlanningSelectorView()
        .environmentObject(PlanningStore())
}
