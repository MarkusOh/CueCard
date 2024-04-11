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
    
    var sortedStacks: [Stack] {
        stacks.sorted(by: >)
    }
    
    var body: some View {
        NavigationStack(path: $navigation) {
            Form {
                ForEach(sortedStacks) { stack in
                    NavigationLink(value: StackEdit(stack: stack)) {
                        Text("Go to \(stack.title)")
                    }
                }
                .onDelete(perform: removeStack)
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
        let stack = Stack(title: "", creationDate: .now)
        context.insert(stack)
        navigation.append(StackEdit(stack: stack))
    }
    
    func removeStack(from indexSet: IndexSet) {
        for index in indexSet {
            context.delete(sortedStacks[index])
        }
    }
}

#Preview {
    ContentView()
}
