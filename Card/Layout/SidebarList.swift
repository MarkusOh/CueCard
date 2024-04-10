//
//  SidebarLayout.swift
//  Card
//
//  Created by Seungsub Oh on 4/10/24.
//

import SwiftUI

struct SidebarList: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = proposal.replacingUnspecifiedDimensions()
        let isLandscape = size.width >= size.height
        
        if isLandscape {
            return .init(width: size.width * 0.5, height: size.height)
        } else {
            return .init(width: size.width * 0.8, height: size.height)
        }
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = 0.0
        let proposal: ProposedViewSize = .init(width: bounds.width, height: bounds.height)
        
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            subview.place(at: .init(x: bounds.minX, y: bounds.minY + y), anchor: .topLeading, proposal: proposal)
            y += size.height
        }
    }
}
