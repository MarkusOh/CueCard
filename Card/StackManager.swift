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
        
        return ScrollViewReader { proxy in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    NavigationLink(value: StackDisplay(stack: stack)) {
                        Text("Display cards in '\(stackTitle)' stack")
                            .formStyleLook()
                    }
                    .padding(.bottom)
                    
                    Text("Stack Title")
                        .formSectionStyleLook()
                    
                    // Index of the title of stack is 0
                    FocusControlledEdit(title: $stack.title, index: 0)
                        .formStyleLook()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            FocusController.shared.focusedIndex = 0
                        }
                        .padding(.bottom)
                    
                    Text("Cards")
                        .formSectionStyleLook()
                    
                    LazyVStack(alignment: .leading) {
                        ForEach(sortedCardsBinding) { $card in
                            CardEditView(card: $card)
                            
                            if card.index != stack.cards.count {
                                Divider()
                            }
                        }
                    }
                    .formStyleLook()
                    .padding(.bottom)
                    
                    Button(action: stack.addAnEmptyCard) {
                        Text("Add a card")
                            .formStyleLook()
                            .transaction { transaction in
                                transaction.animation = nil
                                transaction.disablesAnimations = true
                            }
                    }
                }
                .padding()
            }
        }
        .onSubmit {
            FocusController.shared.focusedIndex = nil
        }
        .navigationTitle("Stack '\(stackTitle)' Details")
        .navigationBarTitleDisplayMode(.inline)
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
