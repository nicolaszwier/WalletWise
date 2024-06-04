//
//  PeriodView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI


struct FiltersView: View {
    let planning: Planning
    @EnvironmentObject var viewModel: TransactionsViewViewModel
    @Binding var filtersViewPresented: Bool
    @State var periodChips: [ChipModel] = [
        ChipModel(titleKey: "Current month", period: FilterPeriod.lastMonth),
        ChipModel(titleKey: "Last three months", period: FilterPeriod.lastThreeMonths),
        ChipModel(titleKey: "Custom", period: FilterPeriod.custom)
    ]
    @State private var isPressed = false
    
    var body: some View {
        
        Text("Filter transactions")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .bold()
            .padding(.top)
        VStack(alignment: .center) {
            GroupBox(label: Text("Period")) {
                ChipContainerView(chipsArray: periodChips, selection: $viewModel.filters.selectedPeriod, selectedChipIndex: periodChips.last?.id)
                
                
                if (viewModel.filters.selectedPeriod.rawValue == FilterPeriod.custom.rawValue) {
                    DatePicker("Start date",
                               selection: $viewModel.filters.startDate,
                               displayedComponents: [.date]
                    )
                    DatePicker("End date",
                        selection: $viewModel.filters.endDate,
                        displayedComponents: [.date]
                    )
                }
            }

            GroupBox(label: Text("Transaction type")) {
                Toggle(isOn: $viewModel.filters.includeExpenses) {
                    Label("Include expenses", image: "")
                }
                .tint(.accentColor)
                Toggle(isOn: $viewModel.filters.includeIncomes) {
                    Label("Include incomes", image: "")
                }
                .tint(.accentColor)
            }
            
            WWButton(label: "Apply filters", background: .accentColor) {
                Task {
                    isPressed.toggle()
                    await viewModel.fetch(planning: planning)
                    filtersViewPresented = false
                }
            }
            .sensoryFeedback(.start, trigger: isPressed)
            Button("Clear filters", systemImage: "xmark") {
                Task {
                    isPressed.toggle()
                    viewModel.clearFilters()
                    filtersViewPresented = false
                }
            }
            .sensoryFeedback(.impact, trigger: isPressed)
            .padding(.top)
            .buttonStyle(.plain)
            .foregroundColor(.red)
            .bold()
            
            Spacer()
        }
        .padding()
    }
    
    
}

#Preview {
    FiltersView(planning: Planning(id: "", description: "", currency: Currency.brl, currentBalance: 0, expectedBalance: 0, dateOfCreation: Date()), filtersViewPresented: .constant(true))
        .environmentObject(TransactionsViewViewModel())
}
