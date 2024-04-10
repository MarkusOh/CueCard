//
//  ChevronButton.swift
//  Card
//
//  Created by Seungsub Oh on 4/10/24.
//

import SwiftUI

struct ChevronButton: View {
    let isLeft: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Color.clear
                .overlay {
                    VStack {
                        HStack(spacing: .zero) {
                            if isLeft {
                                Image(systemName: "arrowshape.backward")
                                Spacer()
                            } else {
                                Spacer()
                                Image(systemName: "arrowshape.forward")
                            }
                        }
                        .font(.title)
                        .foregroundStyle(Color(uiColor: .label).opacity(0.5))
                        
                        Spacer()
                    }
                }
        }
        .accessibilityLabel("Go \(isLeft ? "back" : "forward")")
    }
}

#Preview {
    ChevronButton(isLeft: true, action: {})
}

