//
//  FormStyleLook.swift
//  Card
//
//  Created by Seungsub Oh on 4/15/24.
//

import SwiftUI

struct FormStyleLook: ViewModifier {
    static let vPad = 10.0
    static let hPad = 20.0
    
    func body(content: Content) -> some View {
        HStack(spacing: .zero) {
            content
            Spacer(minLength: .zero)
        }
        .padding(.vertical, Self.vPad)
        .padding(.horizontal, Self.hPad)
        .background(Color(uiColor: .label).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12.5))
    }
}

extension View {
    func formStyleLook() -> some View {
        self.modifier(FormStyleLook())
    }
}
