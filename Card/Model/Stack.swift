//
//  Stack.swift
//  Card
//
//  Created by Seungsub Oh on 3/30/24.
//

import Foundation
import SwiftData

@Model
class Stack: Comparable {
    static func < (lhs: Stack, rhs: Stack) -> Bool {
        lhs.creationDate < rhs.creationDate
    }
    
    var title: String
    @Relationship(deleteRule: .cascade) var cards = [Card]()
    var creationDate: Date
    
    init(title: String, creationDate: Date) {
        self.title = title
        self.creationDate = creationDate
    }
    
    func addAnEmptyCard() {
        let lastIndex = cards.sorted().last?.index ?? 0
        let card: Card = .init(index: lastIndex + 1, title: "", creationDate: .now)
        cards.append(card)
    }
}
