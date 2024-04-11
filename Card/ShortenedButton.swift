//
//  ShortenedButton.swift
//  Card
//
//  Created by Seungsub Oh on 4/11/24.
//

import SwiftUI

struct ShortenedButton: View {
    let index: Int
    let title: String
    let action: () -> Void
    
    var body: some View {
        let shortenedTitle: String
        let upto = 15
        
        if title.count > upto {
            shortenedTitle = "\(title.prefix(upto))..."
        } else {
            shortenedTitle = title
        }
        
        return Button(action: action, label: {
            HStack(spacing: .zero) {
                Color.clear
                    .frame(width: 40, height: 15)
                    .overlay {
                        GeometryReader { _ in
                            Text("\(index)")
                        }
                    }
                
                Text(shortenedTitle)
                    .lineLimit(1)
                    .frame(height: 15)
            }
        })
        .foregroundStyle(Color(uiColor: .label))
    }
}

#Preview {
    ShortenedButton(index: 0, title: "Hethukdlsjfkldsjkfjlkdsfjk", action: {})
}
