//
//  CornerGradience.swift
//  Card
//
//  Created by Seungsub Oh on 4/11/24.
//

import SwiftUI

struct CornerGradience: ViewModifier {
    func body(content: Content) -> some View {
        content
            .mask {
                LinearGradient(colors: [.clear, .black, .black, .black, .black, .clear], startPoint: .top, endPoint: .bottom)
            }
            .mask {
                LinearGradient(colors: [.clear, .black, .black, .black, .black, .clear], startPoint: .leading, endPoint: .trailing)
            }
    }
}

extension View {
    func cornerGradience() -> some View {
        modifier(CornerGradience())
    }
}
