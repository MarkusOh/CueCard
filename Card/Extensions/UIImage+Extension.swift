//
//  UIImage+Extension.swift
//  Card
//
//  Created by Seungsub Oh on 4/13/24.
//

import UIKit

extension UIImage {
    func resizeImage(to maxHeight: CGFloat) -> UIImage {
        let aspectRatio = self.size.width / self.size.height
        var newSize = CGSize(width: self.size.width, height: self.size.height)
        
        // Check if original height is less than 250, if yes, no need to resize
        if self.size.height < maxHeight {
            return self
        }
        
        newSize.height = maxHeight
        newSize.width = floor(maxHeight * aspectRatio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        let newImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return newImage
    }
}
