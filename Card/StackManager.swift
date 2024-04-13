//
//  StackManager.swift
//  Card
//
//  Created by Seungsub Oh on 4/11/24.
//

import SwiftUI
import SwiftData

struct StackManager: View {
    @Bindable var stack: Stack
    
    var sortedCardsBinding: [Binding<Card>] {
        $stack.cards.sorted(by: { $0.wrappedValue.index < $1.wrappedValue.index })
    }
    
    var body: some View {
        let stackTitle = stack.title.count > 0 ? stack.title : String(localized: "Unnamed")
        
        return Form {
            Section {
                NavigationLink(value: StackDisplay(stack: stack)) {
                    Text("Display cards in '\(stackTitle)' stack")
                }
            }
            
            Section("Stack Title") {
                TextField("Enter stack title", text: $stack.title)
            }
            
            Section("Cards") {
                ForEach(sortedCardsBinding) { $card in
                    CardEditView(card: $card)
                }
                
                Button("Add a card", action: stack.addAnEmptyCard)
            }
        }
        .onSubmit(closeKeyboard)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Add a card", action: addAnEmptyCardAndMoveFocus)
                
                Spacer()
                
                Button("Done", action: closeKeyboard)
            }
        }
        .navigationTitle("Stack '\(stackTitle)' Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func closeKeyboard() {
        
    }
    
    func addAnEmptyCardAndMoveFocus() {
        stack.addAnEmptyCard()
        let lastIndex = sortedCardsBinding.last?.wrappedValue.index ?? 1
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Stack.self, configurations: config)
        let example = Stack(title: "", creationDate: .now)
        
        container.mainContext.insert(example)
        
        return NavigationStack {
            StackManager(stack: example)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
