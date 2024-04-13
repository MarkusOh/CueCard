//
//  CardEditView.swift
//  Card
//
//  Created by Seungsub Oh on 4/13/24.
//

import SwiftUI
import SwiftData

struct CardEditView: View {
    @Binding var card: Card
    var focusState: FocusState<StackManager.FocusedField?>.Binding
    
    var body: some View {
        VStack(alignment: .leading) {
            let indexText = Text("\(card.index)")
                .lineLimit(1)
                .frame(width: 35, alignment: .leading)
            let layoutFixText: Binding<String> = card.title.isEmpty ? .constant("Layout Fix") : .constant(card.title)
            
            HStack(alignment: .firstTextBaseline) {
                indexText
                
                TextField("Enter card title", text: layoutFixText, axis: .vertical)
                    .hidden()
                    .overlay {
                        TextField("Enter card title", text: $card.title, axis: .vertical)
                    }
                    .focused(focusState, equals: .cardTitle(card.index))
                
                PhotoPickerButton(image: $card.image)
            }
            
            if let imageData = card.image,
               let image = UIImage(data: imageData)?.resizeImage(to: 100) {
                HStack(alignment: .firstTextBaseline, spacing: .zero) {
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
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Card.self, configurations: config)
        let example = Card(index: 999, title: "", creationDate: .now)
        let focus = FocusState<StackManager.FocusedField?>.init()
        
        container.mainContext.insert(example)
        
        return Form {
            CardEditView(card: .constant(example), focusState: focus.projectedValue)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
