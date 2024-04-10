//
//  CardsIndexView.swift
//  Card
//
//  Created by Seungsub Oh on 4/11/24.
//

import SwiftUI

struct CardsIndexView: View {
    @Binding var currentIndex: Int
    let cards: [Card]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(cards) { card in
                    ShortenedButton(index: card.index, title: card.title) {
                        withAnimation {
                            currentIndex = card.index
                        }
                    }
                }
            }
            .padding()
        }
        .transition(.moveEdgeWithOpacity)
    }
}
