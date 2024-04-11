//
//  StackEdit.swift
//  Card
//
//  Created by Seungsub Oh on 4/11/24.
//

import SwiftUI
import Observation

struct StackEdit: Identifiable, Hashable {
    static func == (lhs: StackEdit, rhs: StackEdit) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID = .init()
    @Bindable var stack: Stack
}
