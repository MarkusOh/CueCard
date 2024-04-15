//
//  VerticalLayout.swift
//  Card
//
//  Created by Seungsub Oh on 4/10/24.
//

import SwiftUI

struct VerticalCarousel: Layout {
    struct Cache {
        var parent: CGRect?
        var subviews: [CGSize]?
    }
    
    var selectedIndex: Int
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        let selectedIndex = Self.clamp(value: selectedIndex, to: 1...subviews.count)
        var y = 0.0
        let proposal: ProposedViewSize = .init(width: bounds.width, height: bounds.height)
        
        if cache.parent == nil ||
            cache.parent! != bounds {
            cache.parent = bounds
            cache.subviews = subviews.map({
                $0.sizeThatFits(.init(
                    width: bounds.width,
                    height: bounds.height
                ))
            })
        }
        
        // get initial y placement
        for index in 0..<(selectedIndex - 1) {
            let size = cache.subviews![index]
            let nextHeight = cache.subviews![safe: index + 1]?.height ?? .zero
            y -= (size.height / 2 + nextHeight / 2)
        }
        
        // place each subview in vertical order
        for index in 0..<subviews.count {
            let size = cache.subviews![index]
            subviews[index].place(at: .init(
                x: bounds.minX,
                y: y + bounds.midY
            ), anchor: .leading, proposal: proposal)
            
            let nextHeight = cache.subviews![safe: index + 1]?.height ?? .zero
            y += (size.height / 2 + nextHeight / 2)
        }
    }
    
    func makeCache(subviews: Subviews) -> Cache { .init() }
    func updateCache(_ cache: inout Cache, subviews: Subviews) {}
    
    static func clamp(value: Int, to limits: ClosedRange<Int>) -> Int {
        return min(max(value, limits.lowerBound), limits.upperBound)
    }
}
