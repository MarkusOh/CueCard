//
//  Card.swift
//  Card
//
//  Created by Seungsub Oh on 3/23/24.
//

import SwiftData

@Model
class Card {
    var index: Int
    var title: String
    
    init(index: Int, title: String) {
        self.index = index
        self.title = title
    }
}
