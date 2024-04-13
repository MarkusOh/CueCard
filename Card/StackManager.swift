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
    @FocusState var keyboardIndex: Int?
    
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
                    .focused($keyboardIndex, equals: 0) // Title will have index-0 for keyboard
            }
            
            Section("Cards") {
                ForEach(sortedCardsBinding) { $card in
                    CardEditView(card: $card, keyboardIndex: $keyboardIndex)
                }
                
                Button("Add a card", action: addAnEmptyCardAndMoveFocus)
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
        keyboardIndex = nil
    }
    
    func addAnEmptyCardAndMoveFocus() {
        Task { @MainActor in
            stack.addAnEmptyCard()
            keyboardIndex = nil
            
            try? await Task.sleep(for: .seconds(0.5))
            
            let lastIndex = sortedCardsBinding.last?.wrappedValue.index ?? 1
            keyboardIndex = lastIndex
        }
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
