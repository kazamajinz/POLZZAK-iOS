//
//  MemberTypeView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/27.
//

import UIKit
import SnapKit

class MemberTypeView: UIView {
    private let memberTypeLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor:.gray700, font: .body14Sbd, textAlignment: .center)
        return label
    }()
    
    init(with text: String) {
        memberTypeLabel.text = text
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

extension MemberTypeView {
    private func setUI() {
        backgroundColor = .gray200
        addBorder(cornerRadius: 8, borderWidth: 1, borderColor: UIColor(white: 0, alpha: 0.12))
        
        addSubview(memberTypeLabel)
        
        memberTypeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configure(with text: String) {
        memberTypeLabel.text = text
    }
}
