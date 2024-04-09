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
    
    let cards: [Card]
    
    init(stack: Stack) {
        self.stack = stack
        self.cards = stack.cards.sorted()
    }
    
    var prevCard: Card? {
        cards.first {
            $0.index == (currentIndex - 1)
        }
    }
    
    var currCard: Card? {
        cards.first {
            $0.index == currentIndex
        }
    }
    
    var nextCard: Card? {
        cards.first {
            $0.index == (currentIndex + 1)
        }
    }
    
    var body: some View {
        cardsView(prevCard: prevCard, currCard: currCard, nextCard: nextCard)
    }
    
    func cardsView(prevCard: Card?, currCard: Card?, nextCard: Card?) -> some View {
        ScrollViewReader { scrollView in
            GeometryReader { proxy in
                VStack(alignment: .leading) {
                    GeometryReader { proxy in
                        VStack(alignment: .leading) {
                            if let prevCard = prevCard {
                                nonMainText(from: prevCard.title)
                            }
                            
                            if let currCard = currCard {
                                mainText(from: currCard.title)
                            }
                            
                            if let nextCard = nextCard {
                                nonMainText(from: nextCard.title)
                            }
                        }
                        .frame(height: proxy.size.height)
                    }
                    .padding()
                    .transaction(value: currentIndex, { transaction in
                        transaction.animation = nil
                    })
                    .overlay {
                        HStack {
                            let pane = GeometryReader(content: {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .frame(width: $0.size.width,
                                           height: $0.size.height)
                            })
                            
                            pane.onTapGesture {
                                withAnimation {
                                    decrementCardIndex()
                                    scrollView.scrollTo(currentIndex)
                                }
                            }
                            pane.onTapGesture {
                                withAnimation {
                                    incrementCardIndex()
                                    scrollView.scrollTo(currentIndex)
                                }
                            }
                        }
                    }
                    
                    allCards(scrollView: scrollView)
                }
                .frame(height: proxy.size.height)
            }
            .background(Color(uiColor: .systemBackground))
        }
    }
    
    func mainText(from string: String) -> some View {
        Text(string)
            .font(.largeTitle)
    }
    
    func nonMainText(from string: String) -> some View {
        Text(string)
            .font(.body)
            .foregroundStyle(Color(uiColor: .label).opacity(0.5))
    }
    
    func allCards(scrollView: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                let width: Double = 800
                let height: Double = 480
                let scale: Double = 0.1
                let selectedScale: Double = 0.15
                
                ForEach(cards) { card in
                    let scaleForCard = (card.index == currentIndex ? selectedScale : scale)
                    let scaleSizeForCard: CGSize = .init(width: scaleForCard, height: scaleForCard)
                    
                    Rectangle()
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .frame(width: width, height: height)
                        .overlay {
                            GeometryReader { proxy in
                                Text(card.title)
                                    .font(.largeTitle)
                                    .padding(.horizontal)
                                    .frame(height: proxy.size.height)
                            }
                        }
                        .scaleEffect(scaleSizeForCard)
                        .frame(width: width * scaleForCard, height: height * scaleForCard)
                        .border(Color(uiColor: .label), width: 2.5)
                        .overlay(alignment: .bottomTrailing) {
                            Text("\(card.index)")
                                .padding(.trailing, 5)
                                .padding(.bottom, 1)
                        }
                        .id(card.index)
                        .onTapGesture {
                            withAnimation {
                                currentIndex = card.index
                                scrollView.scrollTo(card.index)
                            }
                        }
                }
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
        
        return CardsView(stack: example)
    } catch {
        fatalError("Failed to create model container")
    }
}

extension CardsView {
    func decrementCardIndex() {
        currentIndex -= 1
        
        if currentIndex <= 0 {
            currentIndex = cards.count
        }
    }
    
    func incrementCardIndex() {
        currentIndex += 1
        
        if currentIndex > cards.count {
            currentIndex = 1
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
