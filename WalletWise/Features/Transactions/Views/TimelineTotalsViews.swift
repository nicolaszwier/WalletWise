//
//  TimelineTotalsViews.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 11/05/24.
//

import SwiftUI

struct TimelineTotalsViews: View {
    @Binding var expectedBalance: Decimal
    @Binding var currentBalance: Decimal
    @StateObject private var viewModel = TransactionsViewViewModel()
    @State private var isCurrentBalancePopoverPresented: Bool = false
    @State private var isExpectedBalancePopoverPresented: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                Text("Current balance")
                    .foregroundColor(.secondary)
                    .font(.footnote)
                Text(viewModel.formatCurrency(amount: currentBalance))
                    .contentTransition(.numericText())
                    .transaction { t in
                        t.animation = .default
                    }
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.accentColor)
                   
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
                    .foregroundColor(.secondary)
                    .font(.footnote)
                Text(viewModel.formatCurrency(amount: expectedBalance))
                    .contentTransition(.numericText())
                    .transaction { t in
                        t.animation = .default
                    }
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.accentColor)
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
        .padding(.horizontal, 35)
        .padding(.top)
    }
}

#Preview {
    TimelineTotalsViews(expectedBalance: .constant(100), currentBalance: .constant(110))
}
