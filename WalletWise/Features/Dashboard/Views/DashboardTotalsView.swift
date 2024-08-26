//
//  DashboardTotalsView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 08/08/24.
//

import SwiftUI

struct DashboardTotalsView: View {
    @Binding var expectedBalance: Decimal
    @Binding var currentBalance: Decimal
    @State private var isCurrentBalancePopoverPresented: Bool = false
    @State private var isExpectedBalancePopoverPresented: Bool = false
    @EnvironmentObject var planningStore: PlanningStore
    
    var body: some View {
        HStack {
            VStack {
                Text("Current balance")
                    .foregroundColor(.white)
                    .font(.footnote)
                Text(currentBalance.formatted(.currency(code: planningStore.planning?.currency.rawValue ?? "BRL")))
                    .contentTransition(.numericText())
                    .transaction { t in
                        t.animation = .smooth
                    }
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
            }
            .onTapGesture {
                isCurrentBalancePopoverPresented = true
            }
            .popover(isPresented: $isCurrentBalancePopoverPresented, content: {
                Text("The current balance is the total amount that you have today in your planning.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .presentationCompactAdaptation(.none)
            })
            
            Spacer()
            
            VStack {
                Text("Expected balance")
                    .foregroundColor(.white)
                    .font(.footnote)
                Text(expectedBalance.formatted(.currency(code: planningStore.planning?.currency.rawValue ?? "BRL")))
                    .contentTransition(.numericText())
                    .transaction { t in
                        t.animation = .smooth
                    }
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            .onTapGesture {
                isExpectedBalancePopoverPresented = true
            }
            .popover(isPresented: $isExpectedBalancePopoverPresented, content: {
                Text("The expected balance is the expected total amount that you'll have when all pending transactions be paid")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .presentationCompactAdaptation(.none)
            })
        }
        //        .padding(.horizontal, 35)
        //        .padding(.top)
    }
}

#Preview {
    DashboardTotalsView(expectedBalance: .constant(100), currentBalance: .constant(110))
        .environmentObject(PlanningStore())
}
