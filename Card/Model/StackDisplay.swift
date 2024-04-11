//
//  StackDisplay.swift
//  Card
//
//  Created by Seungsub Oh on 4/11/24.
//

import SwiftUI

struct StackDisplay: Identifiable, Hashable {
    static func == (lhs: StackDisplay, rhs: StackDisplay) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID = .init()
    let stack: Stack
}
