//
//  MemberTypeLabel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/01.
//

import UIKit

class MemberTypeLabel: PaddedLabel {
    enum Constants {
        static let padding = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
    
    override init(padding: UIEdgeInsets = Constants.padding) {
        super.init(padding: padding)
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
        self.layer.backgroundColor = UIColor.gray200.cgColor
        self.textAlignment = .center
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.textColor = .gray700
        self.font = .body14Sbd
    }
}
