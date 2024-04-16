import Foundation
import SwiftData
import UIKit

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
    
    func uiImage(resized height: CGFloat?) async -> UIImage? {
        guard let image = image else {
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                let uiImage = UIImage(data: image)
                let resizedUIImage: UIImage?
                
                if let height = height {
                    resizedUIImage = uiImage?.resizeImage(to: height)
                } else {
                    resizedUIImage = uiImage
                }
                
                DispatchQueue.main.async {
                    continuation.resume(returning: resizedUIImage)
                }
            }
        }
    }
}
