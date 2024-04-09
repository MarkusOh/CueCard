import Foundation
import SwiftData

@Model
class Card: Comparable {
    static func < (lhs: Card, rhs: Card) -> Bool {
        lhs.index < rhs.index
    }
    
    var index: Int
    var title: String
    var creationDate: Date
    
    init(index: Int, title: String, creationDate: Date) {
        self.index = index
        self.title = title
        self.creationDate = creationDate
    }
}
