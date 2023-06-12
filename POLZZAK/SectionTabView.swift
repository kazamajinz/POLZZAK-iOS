//
//  SectionTabView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/11.
//

import UIKit
import SnapKit

final class SectionTabView: UIView {
    private let tabLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let tabUnderlineView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(frame: CGRect = .zero, text: String, textColor: UIColor = .gray300, font: UIFont = .subtitle2, textAligment: NSTextAlignment = .center, lineHeight: Int = 2) {
        super.init(frame: frame)
        self.configure(text: text, textColor: textColor, font: font, textAligment: textAligment, lineHeight: lineHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionTabView {
    private func configure(text: String, textColor: UIColor = .gray300, font: UIFont = .subtitle2, textAligment: NSTextAlignment = .center, lineHeight: Int) {
        tabLabel.setLabel(text: text, textColor: textColor, font: font, textAlignment: textAligment)
        tabUnderlineView.backgroundColor = textColor
        
        [tabLabel, tabUnderlineView].forEach {
            addSubview($0)
        }
        
        tabLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(4)
            $0.centerX.equalToSuperview()
        }
        
        tabUnderlineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(lineHeight)
        }
    }
}
