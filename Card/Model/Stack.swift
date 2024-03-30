//
//  Stack.swift
//  Card
//
//  Created by Seungsub Oh on 3/30/24.
//

import Foundation
import SwiftData

@Model
class Stack {
    var title: String
    @Relationship(deleteRule: .cascade) var cards = [Card]()
    var creationDate: Date
    
    init(title: String, creationDate: Date) {
        self.title = title
        self.creationDate = creationDate
    }
}