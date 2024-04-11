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
        let upto = 30
        
        if title.count > upto {
            shortenedTitle = "\(title.prefix(upto))..."
        } else {
            shortenedTitle = title
        }
        
        return Button(action: action, label: {
            HStack(alignment: .firstTextBaseline, spacing: .zero) {
                Text("\(index)")
                    .frame(width: 40, height: 15, alignment: .leading)
                
                Text(shortenedTitle)
                    .lineLimit(1)
                    .frame(height: 15)
            }
            .fixedSize(horizontal: true, vertical: true)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        })
        .foregroundStyle(Color(uiColor: .label))
    }
}

#Preview {
    ShortenedButton(index: 0, title: "Hethukdlsjfkldsjkfjlkdsfjk", action: {})
}
