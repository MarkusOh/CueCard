//
//  FormSectionStyleLook.swift
//  Card
//
//  Created by Seungsub Oh on 4/15/24.
//

import SwiftUI

struct FormSectionStyleLook: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, FormStyleLook.vPad)
            .fontWeight(.semibold)
            .font(.system(size: 14))
            .foregroundStyle(Color(uiColor: .label).opacity(0.8))
    }
}

extension View {
    func formSectionStyleLook() -> some View {
        self.modifier(FormSectionStyleLook())
    }
}
