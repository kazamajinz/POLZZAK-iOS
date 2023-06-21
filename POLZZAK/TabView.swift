//
//  TabView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/11.
//

import UIKit
import SnapKit

protocol TabViewDelegate: AnyObject {
    func tabViewDidSelect(_ tabView: TabView)
}

final class TabView: UIView {
    private var tabConfig: TabConfig
    weak var delegate: TabViewDelegate?
    
    private let tabLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let tabUnderlineView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(frame: CGRect = .zero, tabConfig: TabConfig) {
        self.tabConfig = tabConfig
        super.init(frame: frame)
        self.configure(tabConfig: tabConfig)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabView {
    private func configure(tabConfig: TabConfig) {
        let labelStyle = LabelStyle(text: tabConfig.text, textColor: tabConfig.textColor, font: tabConfig.font, textAlignment: tabConfig.textAlignment)
        tabLabel.setLabel(style: labelStyle)
        tabUnderlineView.backgroundColor = tabConfig.lineColor
        
        [tabLabel, tabUnderlineView].forEach {
            addSubview($0)
        }
        
        tabLabel.snp.makeConstraints {
            $0.top.equalToSuperview()//.inset(8)
            $0.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        tabUnderlineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    @objc private func handleTap() {
        selectedTab()
        delegate?.tabViewDidSelect(self)
    }
    
    func deselectedTab() {
        tabLabel.textColor = tabConfig.textColor
        tabUnderlineView.backgroundColor = tabConfig.lineColor
    }
    
    func selectedTab() {
        tabLabel.textColor = tabConfig.selectTextColor
        tabUnderlineView.backgroundColor = tabConfig.selectLineColor
    }
}
