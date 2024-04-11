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
    
    @State var navigation = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigation) {
            Form {
                ForEach(stacks) { stack in
                    NavigationLink(value: StackEdit(stack: stack)) {
                        Text("Go to \(stack.title)")
                    }
                }
            }
            .toolbar {
                Button("Add Stack", action: addStack)
            }
            .navigationDestination(for: StackEdit.self) { stackEdit in
                StackManager(stack: stackEdit.stack)
            }
            .navigationDestination(for: StackDisplay.self) { stackDisplay in
                CardsView(stack: stackDisplay.stack)
            }
            .navigationTitle("CueCard")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func addStack() {
        let stack = Stack(title: "Hello there", creationDate: .now)
        
        context.insert(stack)
        
        let card1: Card = .init(index: 1, title: "Hello world", creationDate: .now)
        let card2: Card = .init(index: 2, title: "Hello world 2", creationDate: .now)
        let card3: Card = .init(index: 3, title: "Hello world 3", creationDate: .now)
        let card4: Card = .init(index: 4, title: "Hello world 4", creationDate: .now)
        let card5: Card = .init(index: 5, title: "Hello world 5 dsakjdklsajkdljksajkd\ndsjfklsdkfjk", creationDate: .now)
        let card6: Card = .init(index: 6, title: "Hello world 6", creationDate: .now)
        let card7: Card = .init(index: 7, title: "Hello world 7", creationDate: .now)
        let card8: Card = .init(index: 8, title: "Hello world 8", creationDate: .now)
        let card9: Card = .init(index: 9, title: "Hello world 9", creationDate: .now)
        let card10: Card = .init(index: 10, title: "Hello world 10", creationDate: .now)
        let card11: Card = .init(index: 11, title: "Hello world 11", creationDate: .now)
        let card12: Card = .init(index: 12, title: "Hello world 12fjkldsjkfldsjkfljsdkljfkljsakjfkjklsdjfklsdjfkjds\nfdjkslfjkdlsjfklsjdfkljsdkljfkjsdlfjksldkjfklsdjf\nfjkdlsjfk", creationDate: .now)
        
        stack.cards.append(card1)
        stack.cards.append(card2)
        stack.cards.append(card3)
        stack.cards.append(card4)
        stack.cards.append(card5)
        stack.cards.append(card6)
        stack.cards.append(card7)
        stack.cards.append(card8)
        stack.cards.append(card9)
        stack.cards.append(card10)
        stack.cards.append(card11)
        stack.cards.append(card12)
    }
}

#Preview {
    ContentView()
}
