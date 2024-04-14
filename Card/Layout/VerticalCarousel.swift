//
//  VerticalLayout.swift
//  Card
//
//  Created by Seungsub Oh on 4/10/24.
//

import SwiftUI

struct VerticalCarousel: Layout {
    var selectedIndex: Int
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout [CGSize]) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout [CGSize]) {
        let selectedIndex = Self.clamp(value: selectedIndex, to: 1...subviews.count)
        var y = 0.0
        let proposal: ProposedViewSize = .init(width: bounds.width, height: bounds.height)
        
        // get initial y placement
        for index in 0..<selectedIndex - 1 {
            let height = cache[index].height
            let nextHeight = cache[safe: index + 1]?.height ?? .zero
            y -= (height / 2 + nextHeight / 2)
        }
        
        // place each subview in vertical order
        for (index, subview) in subviews.enumerated() {
            let size = cache[index]
            subview.place(at: .init(x: bounds.minX, y: y + bounds.midY), anchor: .leading, proposal: proposal)
            
            let nextHeight = cache[safe: index + 1]?.height ?? .zero
            y += (size.height / 2 + nextHeight / 2)
        }
    }
    
    func makeCache(subviews: Subviews) -> [CGSize] {
        subviews.map { subview in
            subview.sizeThatFits(.infinity)
        }
    }
    
    func updateCache(_ cache: inout [CGSize], subviews: Subviews) {
        cache = subviews.map { subview in
            subview.sizeThatFits(.infinity)
        }
    }
    
    static func clamp(value: Int, to limits: ClosedRange<Int>) -> Int {
        return min(max(value, limits.lowerBound), limits.upperBound)
    }
}
