//
//  ChipContainerView.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 20/05/24.
//

import SwiftUI

struct ChipContainerView: View {
    @State var chipsArray: [ChipModel]
    @Binding var selection: FilterPeriod
    @State var selectedChipIndex: UUID? = nil
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return GeometryReader { geo in
            ZStack(alignment: .topLeading, content: {
                ForEach(Array(chipsArray.enumerated()), id: \.offset) { index, data in
                    ChipView(chip: data, selectedChipIndex: $selectedChipIndex)
                        .onTapGesture {
                            withAnimation {
                                selectChip(chip: $chipsArray[index])
                            }
                        }
                        .sensoryFeedback(.increase, trigger: selectedChipIndex)
                        .padding(.all, 5)
                        .alignmentGuide(.leading) { dimension in
                            if (abs(width - dimension.width) > geo.size.width) {
                                width = 0
                                height -= dimension.height
                            }
                            let result = width
                            if data.id == chipsArray.last!.id {
                                width = 0
                            } else {
                                width -= dimension.width
                            }
                            return result
                        }
                        .alignmentGuide(.top) { dimension in
                            let result = height
                            if data.id == chipsArray.last!.id {
                                height = 0
                            }
                            return result
                        }
                }
            })
        }
        .frame(maxHeight: 100)
    }
    
    func selectChip(chip: Binding<ChipModel>) {
        selectedChipIndex = chip.wrappedValue.id
        selection = chip.wrappedValue.period
    }
}

#Preview {
    ChipContainerView(chipsArray: [
        ChipModel(titleKey: "Last four periods", period: FilterPeriod.lastMonth),
        ChipModel(titleKey: "Last eight periods", period: FilterPeriod.lastThreeMonths),
        ChipModel(titleKey: "Custom", period: FilterPeriod.custom)
    ], selection: .constant(FilterPeriod.lastMonth))
}
