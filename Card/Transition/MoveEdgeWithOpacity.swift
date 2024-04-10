//
//  MoveEdgeWithOpacity.swift
//  Card
//
//  Created by Seungsub Oh on 4/10/24.
//

import SwiftUI

struct MoveEdgeWithOpacityLayout: Layout {
    var show: Bool
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let proposal: ProposedViewSize = .init(width: bounds.width, height: bounds.height)
        
        subviews.first?.place(
            at: .init(x: bounds.maxX, y: bounds.minY),
            anchor: show ? .topTrailing : .topLeading,
            proposal: proposal
        )
    }
}

struct MoveEdgeWithOpacityModifier: ViewModifier {
    var show: Bool
    
    func body(content: Content) -> some View {
        MoveEdgeWithOpacityLayout(show: show) {
            content
                .opacity(show ? 1 : 0)
        }
    }
}

extension AnyTransition {
    static var moveEdgeWithOpacity: AnyTransition {
        .modifier(
            active: MoveEdgeWithOpacityModifier(show: false),
            identity: MoveEdgeWithOpacityModifier(show: true)
        )
    }
}
