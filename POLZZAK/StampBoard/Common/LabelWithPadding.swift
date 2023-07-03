//
//  LabelWithPadding.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/25.
//

import UIKit

class LabelWithPadding: UILabel {
    private let padding: UIEdgeInsets

    init(frame: CGRect = .zero, padding: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
        self.padding = padding
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
