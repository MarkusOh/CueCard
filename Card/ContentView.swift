//
//  ContentView.swift
//  Card
//
//  Created by Seungsub Oh on 3/30/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    
    @Query var stacks: [Stack]
    
    @State var navigation = [Stack]()
    
    var body: some View {
        NavigationStack(path: $navigation) {
            Form {
                ForEach(stacks) { stack in
                    NavigationLink(value: stack) {
                        Text("Go to \(stack.title)")
                    }
                }
            }
            .toolbar {
                Button("Add Stack", action: addStack)
            }
            .navigationDestination(for: Stack.self) { stack in
                CardsView(stack: stack)
            }
        }
    }
    
    func addStack() {
        let stack = Stack(title: "Hello there", creationDate: .now)
        
        context.insert(stack)
        
        let card1: Card = .init(index: 1, title: "Hello world", creationDate: .now)
        let card2: Card = .init(index: 2, title: "Hello world 2", creationDate: .now)
        let card3: Card = .init(index: 3, title: "Hello world 3", creationDate: .now)
        let card4: Card = .init(index: 4, title: "Hello world 4", creationDate: .now)
        let card5: Card = .init(index: 5, title: "Hello world 5", creationDate: .now)
        
        stack.cards.append(card1)
        stack.cards.append(card2)
        stack.cards.append(card3)
        stack.cards.append(card4)
        stack.cards.append(card5)
    }
}

#Preview {
    ContentView()
}
