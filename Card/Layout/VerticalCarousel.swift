//
//  VerticalLayout.swift
//  Card
//
//  Created by Seungsub Oh on 4/10/24.
//

import SwiftUI

struct VerticalCarousel: Layout {
    var selectedIndex: Int
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let selectedIndex = Self.clamp(value: selectedIndex, to: 1...subviews.count)
        var y = 0.0
        let proposal: ProposedViewSize = .init(width: bounds.width, height: bounds.height)
        
        // get initial y placement
        for (index, upperSubview) in subviews.prefix(upTo: selectedIndex - 1).enumerated() {
            let size = upperSubview.sizeThatFits(proposal)
            let nextHeight = subviews[safe: index + 1]?.sizeThatFits(proposal).height ?? .zero
            y -= (size.height / 2 + nextHeight / 2)
        }
        
        // place each subview in vertical order
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(proposal)
            subview.place(at: .init(x: bounds.minX, y: y + bounds.midY), anchor: .leading, proposal: proposal)
            
            let nextHeight = subviews[safe: index + 1]?.sizeThatFits(proposal).height ?? .zero
            y += (size.height / 2 + nextHeight / 2)
        }
    }
    
    static func clamp(value: Int, to limits: ClosedRange<Int>) -> Int {
        return min(max(value, limits.lowerBound), limits.upperBound)
    }
}
