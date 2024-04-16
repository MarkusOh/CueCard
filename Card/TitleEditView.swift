//
//  TitleEditView.swift
//  Card
//
//  Created by Seungsub Oh on 4/15/24.
//

import SwiftUI

struct TitleEditView: View {
    @Binding var title: String
    let index: Int
    
    @FocusState var isFocused: Bool
    
    @ViewBuilder var body: some View {
        let originalText = mainText
        
        if FocusController.shared.focusedCardIndex == index {
            originalText
                .hidden()
                .overlay {
                    TextField("Enter card title", text: $title)
                        .focused($isFocused)
                        .onSubmit {
                            isFocused = false
                            FocusController.shared.focusedCardIndex = nil
                        }
                        .onAppear {
                            isFocused = true
                        }
                        .onVisibilityChanged { isVisible in
                            guard isVisible == false,
                                  isFocused == true else {
                                return
                            }
                            
                            isFocused = false
                            FocusController.shared.focusedCardIndex = nil
                        }
                }
        } else {
            originalText
        }
    }
    
    var mainText: some View {
        let title: String
        let color: Color
        
        if self.title.isEmpty {
            title = String(localized: "Enter card title")
            color = Color(uiColor: .label).opacity(0.3)
        } else {
            title = self.title
            color = Color(uiColor: .label)
        }
        
        return HStack(spacing: .zero) {
            Text(title)
                .foregroundStyle(color)
            Spacer(minLength: .zero)
        }
    }
}

#Preview {
    TitleEditView(title: .constant("Title!"), index: 1)
}
