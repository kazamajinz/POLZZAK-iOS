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
    weak var delegate: TabViewDelegate?
    
    let tabLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let newAlertImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .circle6
        imageView.isHidden = true
        return imageView
    }()
    
    let underlineView: UIView = {
        let view = UIView()
        return view
    }()
    
    var selectTextColor: UIColor = .blue500 {
        didSet {
            if true == isSelected {
                tabLabel.textColor = selectTextColor
            }
        }
    }
    
    var selectFont: UIFont = .subtitle16Bd {
        didSet {
            if true == isSelected {
                tabLabel.font = selectFont
            }
        }
    }
    
    var selectLineColor: UIColor = .blue500 {
        didSet {
            if true == isSelected {
                underlineView.backgroundColor = selectLineColor
            }
        }
    }
    
    var selectLineHeight: CGFloat = 2.0 {
        didSet {
            if true == isSelected {
                underlineHeightConstraint?.update(offset: selectLineHeight)
            }
        }
    }
    
    var deselectTextColor: UIColor = .gray300 {
        didSet {
            if false == isSelected {
                tabLabel.textColor = deselectTextColor
            }
        }
    }
    
    var deselectFont: UIFont = .subtitle16Bd {
        didSet {
            if false == isSelected {
                tabLabel.font = deselectFont
            }
        }
    }
    
    var deselectLineColor: UIColor = .gray300 {
        didSet {
            if false == isSelected {
                underlineView.backgroundColor = deselectLineColor
            }
        }
    }
    
    var deselectLineHeight: CGFloat = 2.0 {
        didSet {
            if false == isSelected {
                underlineHeightConstraint?.update(offset: deselectLineHeight)
            }
        }
    }
    
    var textAliment: NSTextAlignment = .center
    var underlineHeightConstraint: Constraint?
    var isSelected: Bool = false
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUI()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabView {
    private func setUI() {
        [tabLabel, newAlertImage, underlineView].forEach {
            addSubview($0)
        }
        
        tabLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
        }
        
        newAlertImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(tabLabel.snp.trailing).offset(3)
            $0.width.height.equalTo(6)
        }
        
        underlineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            if true == isSelected {
                underlineHeightConstraint = $0.height.equalTo(selectLineHeight).constraint
            } else {
                underlineHeightConstraint = $0.height.equalTo(deselectLineHeight).constraint
            }
            
        }
    }
    
    @objc private func handleTap() {
        delegate?.tabViewDidSelect(self)
    }
    
    func selectedTab() {
        isSelected = true
        tabLabel.textColor = selectTextColor
        underlineView.backgroundColor = selectLineColor
        underlineHeightConstraint?.update(offset: selectLineHeight)
    }
    
    func deselectedTab() {
        isSelected = false
        tabLabel.textColor = deselectTextColor
        underlineView.backgroundColor = deselectLineColor
        underlineHeightConstraint?.update(offset: deselectLineHeight)
    }
}
