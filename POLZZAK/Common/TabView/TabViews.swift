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
    private var didSetupTabViews = false
    private var selectedTab: TabView?
    var index: Int = 0
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private let screenWidth = UIApplication.shared.width
    private var tabViews: [TabView]
    
    var tabTitles: [String] = [] {
        didSet {
            for title in tabTitles {
                let tabView = TabView()
                tabView.tabLabel.text = title
                tabViews.append(tabView)
            }
            setTabviews()
        }
    }
    
    var selectTextColor: UIColor = .blue500 {
        didSet {
            tabViews.forEach {
                $0.selectTextColor = selectTextColor
            }
        }
    }
    
    var selectFont: UIFont = .subtitle2 {
        didSet {
            tabViews.forEach {
                $0.selectFont = selectFont
            }
        }
    }
    
    var textAliment: NSTextAlignment = .center {
        didSet {
            tabViews.forEach {
                $0.textAliment = textAliment
            }
        }
    }
    
    var selectLineColor: UIColor = .blue500 {
        didSet {
            tabViews.forEach {
                $0.selectLineColor = selectLineColor
            }
        }
    }
    
    var selectLineHeight: CGFloat = 2.0 {
        didSet {
            tabViews.forEach {
                $0.selectLineHeight = selectLineHeight
            }
        }
    }
    
    var deselectTextColor: UIColor = .gray300 {
        didSet {
            tabViews.forEach {
                $0.deselectTextColor = deselectTextColor
            }
        }
    }
    
    var deselectFont: UIFont = .subtitle2 {
        didSet {
            tabViews.forEach {
                $0.deselectFont = deselectFont
            }
        }
    }
    
    var deselectLineColor: UIColor = .gray300 {
        didSet {
            tabViews.forEach {
                $0.deselectLineColor = deselectLineColor
            }
        }
    }
    
    var deselectLineHeight: CGFloat = 2.0 {
        didSet {
            tabViews.forEach {
                $0.deselectLineHeight = deselectLineHeight
            }
        }
    }
    
    init(frame: CGRect = .zero, tabViews: [TabView] = []) {
        self.tabViews = tabViews
        super.init(frame: frame)
        setTabviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabViews {
    func setTabviews() {
        let tabWidth = screenWidth / CGFloat(tabViews.count)
        
        for (index, tabView) in tabViews.enumerated() {
            tabView.delegate = self
            
            tabView.tag = index
            tabView.tabLabel.textAlignment = textAliment
            
            tabView.snp.makeConstraints {
                $0.width.equalTo(tabWidth)
            }
            
            if index == 0 {
                tabView.isSelected = true
                tabView.selectLineHeight = selectLineHeight
                tabView.selectTextColor = selectTextColor
                tabView.selectFont = selectFont
                tabView.selectLineColor = selectLineColor
                tabView.selectLineHeight = selectLineHeight
                selectedTab = tabView
                tabView.selectedTab()
            } else {
                tabView.isSelected = false
                tabView.deselectLineHeight = deselectLineHeight
                tabView.deselectTextColor = deselectTextColor
                tabView.deselectFont = deselectFont
                tabView.deselectLineColor = deselectLineColor
                tabView.deselectLineHeight = deselectLineHeight
                tabView.deselectedTab()
            }
            
            addArrangedSubview(tabView)
        }
    }
}

extension TabViews: TabViewDelegate {
    func tabViewDidSelect(_ tabView: TabView) {
        if selectedTab != tabView {
            selectedTab?.deselectedTab()
            
            tabView.selectedTab()
            selectedTab = tabView
            delegate?.tabViews(self, didSelectTabAtIndex: tabView.tag)
        }
    }
}
