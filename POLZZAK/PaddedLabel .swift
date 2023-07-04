//
//  PaddedLabel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/02.
//

import UIKit

final class PaddedLabel: UILabel {
    
    var padding = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.width += padding.left + padding.right
        newSize.height += padding.top + padding.bottom
        return newSize
    }
}
