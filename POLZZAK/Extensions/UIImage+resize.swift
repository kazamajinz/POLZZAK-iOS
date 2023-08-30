//
//  UIImage+resize.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/28.
//

import UIKit

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / size.width
        let newHeight = size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}
