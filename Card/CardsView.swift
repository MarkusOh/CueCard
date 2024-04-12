//
//  ContentView.swift
//  Card
//
//  Created by Seungsub Oh on 3/23/24.
//

import SwiftUI
import SwiftData

struct CardsView: View {
    @Bindable var stack: Stack
    @State private var currentIndex = 1
    @State private var showIndex = false
    
    let cards: [Card]
    
    init(stack: Stack) {
        self.stack = stack
        self.cards = stack.cards.sorted()
    }
    
    var body: some View {
        cardsView
            .navigationTitle(stack.title)
            .overlay {
                HStack(spacing: .zero) {
                    Spacer()
                    
                    if showIndex {
                        CardsIndexView(currentIndex: $currentIndex, show: $showIndex, cards: cards)
                    }
                }
            }
            .toolbar {
                Button {
                    withAnimation {
                        showIndex.toggle()
                    }
                } label: {
                    Label("Index", systemImage: "list.bullet")
                        .labelStyle(.titleAndIcon)
                }
            }
    }
    
    var cardsView: some View {
        VerticalCarousel(selectedIndex: currentIndex) {
            ForEach(cards) { card in
                let scale = card.index == currentIndex ? 1.0 : 0.5
                
                ZStack(alignment: .leading) {
                    if let imageData = card.image,
                       let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: 250,
                                alignment: .trailing
                            )
                            .padding(.vertical)
                            .drawingGroup()
                    }
                    
                    Text(card.title)
                        .font(
                            .system(size: 70)
                        )
                        .minimumScaleFactor(0.4)
                        .scaleEffect(x: scale, y: scale, anchor: .leading)
                        .shadow(color: Color(uiColor: .systemBackground), radius: 10)
                        .shadow(color: Color(uiColor: .systemBackground), radius: 10)
                }
            }
        }
        .overlay {
            FullHStack() {
                ChevronButton(isLeft: true, action: decrementCardIndex)
                ChevronButton(isLeft: false, action: incrementCardIndex)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Stack.self, configurations: config)
        let example = Stack(title: "Example Stack", creationDate: .now)
        
        container.mainContext.insert(example)
        
        let card1: Card = .init(index: 1, title: "Hello world", creationDate: .now)
        let card2: Card = .init(index: 2, title: "Hello world 2", creationDate: .now)
        let card3: Card = .init(index: 3, title: "Hello world 3", creationDate: .now)
        let card4: Card = .init(index: 4, title: "Hello world 4", creationDate: .now)
        let card5: Card = .init(index: 5, title: "Hello world 5", creationDate: .now)
        
        example.cards.append(contentsOf: [
            card1, card2, card3, card4, card5
        ])
        
        return NavigationStack { CardsView(stack: example) }
            .navigationBarTitleDisplayMode(.inline)
    } catch {
        fatalError("Failed to create model container")
    }
}

extension CardsView {
    func decrementCardIndex() {
        withAnimation {
            currentIndex -= 1
            
            if currentIndex <= 0 {
                currentIndex = cards.count
            }
        }
    }
    
    func incrementCardIndex() {
        withAnimation {
            currentIndex += 1
            
            if currentIndex > cards.count {
                currentIndex = 1
            }
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
