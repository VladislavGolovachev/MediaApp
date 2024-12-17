//
//  UIImageExtension.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import UIKit

extension UIImage {
    func resizedTo(constant: CGFloat, by side: Side) -> UIImage {
        let size = self.size
        var multiplier: CGFloat = 1
        
        if side == .height {
            multiplier = constant / size.height
        } else {
            multiplier = constant / size.width
        }
        
        let newSize = CGSize(width: size.width * multiplier,
                             height: size.height * multiplier)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        let newImage = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return newImage
    }
}

enum Side {
    case width
    case height
}
