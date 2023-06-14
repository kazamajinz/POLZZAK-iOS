//
//  TabViews.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/13.
//

import UIKit
import SnapKit

protocol TabViewsDelegate: AnyObject {
    func tabViews(_ tabViews: TabViews, didSelectTabAtIndex index: Int)
}

final class TabViews: UIStackView {
    weak var delegate: TabViewsDelegate?
//    private var tabs: [TabView] = []
    var tabActions: [() -> Void] = []
    
    private var selectedTab: TabView?
    
    init(frame: CGRect = .zero, tabStyle: TabStyle) {
        super.init(frame: frame)
        setupTabViews(tabConfig: tabStyle.tabConfig)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupTabViews(tabConfig: TabConfig) {
        let screenWidth = UIScreen.main.bounds.width
        let tabWidth = screenWidth / CGFloat(tabConfig.textArray.count)
        
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        
        for (index, tabViewText) in tabConfig.textArray.enumerated() {
            let customTabConfig = TabConfig(
                text: tabViewText,
                textColor: tabConfig.textColor,
                font: tabConfig.font,
                lineColor: tabConfig.lineColor,
                lineHeight: tabConfig.lineHeight,
                selectTextColor: tabConfig.selectTextColor,
                selectLineColor: tabConfig.selectLineColor,
                selectLineHeight: tabConfig.selectLineHeight
            )
            
            let tabView = TabView(tabConfig: customTabConfig)
            tabView.delegate = self
            tabView.tag = index
            
            tabView.snp.makeConstraints {
                $0.width.equalTo(tabWidth)
            }
            
            addArrangedSubview(tabView)
            
            if index == 0 {
                tabView.selectedTab()
                selectedTab = tabView
            }
        }
        
    }
    
    private func setAction(_ tabActions: [() -> Void]) {
        self.tabActions = tabActions
    }
}

extension TabViews: TabViewDelegate {
    func tabViewDidSelect(_ tabView: TabView) {
        selectedTab?.deselectedTab()
        tabView.selectedTab()
        selectedTab = tabView
        delegate?.tabViews(self, didSelectTabAtIndex: tabView.tag)
    }
}
