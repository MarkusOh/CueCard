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
    @State private var currentIndex = 0
    @State private var showIndex = false
    
    @Namespace private var cardNS
    let height: Double = 300
    let scaleDown: Double = 0.8
    let backgroundColor = Color(red: 30/255, green: 30/255, blue: 30/255)
    
    let cards: [Card]
    
    init(stack: Stack) {
        self.stack = stack
        self.cards = stack.cards.sorted()
    }
    
    var body: some View {
        mainView
            .navigationTitle(stack.title)
            .background {
                Color(red: 30/255, green: 30/255, blue: 30/255)
                    .ignoresSafeArea()
            }
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
    
    var mainView: some View {
        carousel
            .overlay {
                FullHStack() {
                    ChevronButton(isLeft: true, action: decrementCardIndex)
                    ChevronButton(isLeft: false, action: incrementCardIndex)
                }
            }
    }
    
    func cardView(from card: Card?, index: Int) -> some View {
        Group {
            if let card = card {
                ZStack(alignment: .leading) {
                    Color.clear
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                    
                    if let imageData = card.image,
                       let uiImage = UIImage(data: imageData) {
                        HStack(spacing: .zero) {
                            Spacer(minLength: .zero)
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    
                    Text(card.title)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height)
                .background(Color(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .id(UUID())
                .matchedGeometryEffect(id: index, in: cardNS)
            } else {
                Color.clear
                    .frame(maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height)
                    .contentShape(Rectangle())
            }
        }
    }
    
    var carousel: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardView(from: cards[safe: currentIndex - 2], index: currentIndex - 2)
                .scaleEffect(scaleDown / 2, anchor: .leading)
            
            cardView(from: cards[safe: currentIndex - 1], index: currentIndex - 1)
                .scaleEffect(scaleDown, anchor: .leading)
            
            cardView(from: cards[safe: currentIndex], index: currentIndex)
            
            cardView(from: cards[safe: currentIndex + 1], index: currentIndex + 1)
                .scaleEffect(scaleDown, anchor: .leading)
            
            cardView(from: cards[safe: currentIndex + 2], index: currentIndex + 2)
                .scaleEffect(scaleDown / 2, anchor: .leading)
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
            
            if currentIndex < 0 {
                currentIndex = cards.count - 1
            }
        }
    }
    
    func incrementCardIndex() {
        withAnimation {
            currentIndex += 1
            
            if currentIndex >= cards.count {
                currentIndex = 0
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
