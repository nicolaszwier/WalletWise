//
//  ChipView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 20/05/24.
//

import SwiftUI

struct ChipModel: Identifiable {
    let id = UUID()
    let titleKey: LocalizedStringKey
    let period: FilterPeriod
}

struct ChipView: View {
    var chip: ChipModel
    @Binding var selectedChipIndex: UUID?

    var body: some View {
        Text(chip.titleKey)
            .lineLimit(1)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .foregroundColor(selectedChipIndex == chip.id ? .white : .secondary)
            .background(selectedChipIndex == chip.id ? .accentColor : Color(UIColor.tertiarySystemBackground))
            .cornerRadius(20)
            .font(.title3)
            .bold()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(selectedChipIndex == chip.id ? .accentColor : Color(UIColor.quaternarySystemFill), lineWidth: 1.5)
                
            )
            .transition(.slide)
    }
}

#Preview {
    ChipView(chip: ChipModel(titleKey: "Last four periods", period: FilterPeriod.lastMonth), selectedChipIndex: .constant(UUID()))
}
