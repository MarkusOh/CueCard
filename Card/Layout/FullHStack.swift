//
//  FullHStack.swift
//  Card
//
//  Created by Seungsub Oh on 4/10/24.
//

import SwiftUI

struct FullHStack: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let offeredWidth = bounds.width / Double(subviews.count)
        let proposal = ProposedViewSize(width: offeredWidth, height: bounds.height)
        var x = bounds.minX
        
        for subview in subviews {
            subview.place(at: .init(x: x, y: bounds.midY), anchor: .leading, proposal: proposal)
            x += offeredWidth
        }
    }
}
