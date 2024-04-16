//
//  CardEditView.swift
//  Card
//
//  Created by Seungsub Oh on 4/13/24.
//

import SwiftUI
import SwiftData

@Observable
class FocusController {
    static var shared = FocusController()
    var focusedCardIndex: Int?
    
    private init() {}
}

struct CardEditView: View {
    @Binding var card: Card
    @State private var image: Image?
    
    var body: some View {
        VStack(alignment: .leading) {
            let indexText = Text("\(card.index)")
                .lineLimit(1)
                .frame(width: 35, alignment: .leading)
            
            HStack(alignment: .firstTextBaseline, spacing: .zero) {
                indexText
                
                TitleEditView(title: $card.title, index: card.index)
                
                PhotoPickerButton(image: $card.image)
            }
            
            if let image = image {
                HStack(alignment: .firstTextBaseline, spacing: .zero) {
                    indexText.hidden()
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            FocusController.shared.focusedCardIndex = card.index
        }
        .task {
            guard let uiImage = await card.uiImage(resized: 150) else {
                return
            }
            
            image = Image(uiImage: uiImage)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Card.self, configurations: config)
        let example = Card(index: 999, title: "", creationDate: .now)
        
        container.mainContext.insert(example)
        
        return Form {
            CardEditView(card: .constant(example))
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
