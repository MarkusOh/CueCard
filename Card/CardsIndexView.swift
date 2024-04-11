//
//  CardsIndexView.swift
//  Card
//
//  Created by Seungsub Oh on 4/11/24.
//

import SwiftUI

struct CardsIndexView: View {
    @Binding var currentIndex: Int
    @Binding var show: Bool
    let cards: [Card]
    
    var body: some View {
        HStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        show.toggle()
                    }
                }
            
            ScrollView(.vertical) {
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
            .scrollClipDisabled()
            .padding()
            .background(VisualEffectView(effect: UIBlurEffect(style: .regular)))
            .clipShape(
                RoundedRectangle(cornerRadius: 15)
            )
        }
        .transition(.moveEdgeWithOpacity)
    }
}
