import Foundation
import SwiftData

@Model
class Card: Identifiable, Comparable {
    static func < (lhs: Card, rhs: Card) -> Bool {
        lhs.index < rhs.index
    }
    
    var id: UUID
    var index: Int
    var title: String
    
    @Attribute(.externalStorage) var image: Data?
    
    var creationDate: Date
    
    init(index: Int, title: String, creationDate: Date) {
        self.id = .init()
        self.index = index
        self.title = title
        self.creationDate = creationDate
    }
}
