import Foundation
import SwiftData

@Model
class Card {
    var title: String
    var creationDate: Date
    
    init(title: String, creationDate: Date) {
        self.title = title
        self.creationDate = creationDate
    }
}
