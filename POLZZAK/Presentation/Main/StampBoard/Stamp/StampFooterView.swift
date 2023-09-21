//
//  StampFooterView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/22.
//

import UIKit

import SnapKit

class StampFooterView: UICollectionReusableView {
    static let reuseIdentifier = "StampFooterView"
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let moreButton = MoreButton(title: "펼치기", titleWhenSelected: "접기")
    
    var actionWhenUserTapMoreButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureMoreButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StampFooterView {
    private func configureLayout() {
        addSubview(separator)
        addSubview(moreButton)
        
        separator.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1.5) // TODO: 피그마에는 height가 0으로 나와서 1.5로 해놨는데 바꿔야 함 (2023.05.23)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureMoreButton() {
        moreButton.addAction(
            UIAction(handler: { [weak self] _ in
                self?.moreButton.isSelected.toggle()
                self?.actionWhenUserTapMoreButton?()
            }),
            for: .touchUpInside
        )
    }
}
