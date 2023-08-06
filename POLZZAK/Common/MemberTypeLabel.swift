//
//  MemberTypeLabel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/01.
//

import UIKit

class MemberTypeLabel: PaddedLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
        self.layer.backgroundColor = UIColor.gray200.cgColor
        self.textAlignment = .center
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.textColor = .gray700
        self.font = .body14Sbd
        self.padding = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
}

