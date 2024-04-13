//
//  BecomingVisible.swift
//  Card
//
//  Created by Seungsub Oh on 4/13/24.
//

import SwiftUI

public extension View {
    func onVisibilityChanged(perform action: @escaping (_ isVisible: Bool) -> Void) -> some View {
        modifier(VisibilityChanged(action: action))
    }
}

private struct VisibilityChanged: ViewModifier {
    @Environment(\.appBoundary) var appBoundary
    
    @State var action: ((_ isVisible: Bool) -> Void)?
    
    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: VisibleKey.self,
                        value: appBoundary.intersects(proxy.frame(in: .global))
                    )
                    .onPreferenceChange(VisibleKey.self) { isVisible in
                        action?(isVisible)
                    }
            }
        }
    }
    
    struct VisibleKey: PreferenceKey {
        static var defaultValue: Bool = false
        static func reduce(value: inout Bool, nextValue: () -> Bool) { }
    }
}
