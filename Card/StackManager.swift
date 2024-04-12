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
                    VStack(alignment: .leading) {
                        let indexText = Text("\($card.wrappedValue.index)")
                            .frame(width: 100, height: 100)
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 8)
                        
                        HStack(alignment: .firstTextBaseline) {
                            indexText
                            TextField("Enter card title", text: $card.title)
                            PhotoPickerButton(image: $card.image)
                        }
                        
                        if let imageData = $card.wrappedValue.image,
                           let image = UIImage(data: imageData) {
                            HStack(alignment: .firstTextBaseline) {
                                indexText.hidden()
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                    }
                }
                
                Button("Add a card", action: stack.addAnEmptyCard)
            }
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
