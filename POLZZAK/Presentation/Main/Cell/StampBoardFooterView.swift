//
//  StampBoardFooterView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/24.
//

import UIKit
import SnapKit

final class StampBoardFooterView: UICollectionReusableView {
    static let reuseIdentifier = "StampBoardFooterView"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .horizontal, spacing: 2)
        stackView.alignment = .center
        return stackView
    }()
    
    private let currentPage: UILabel = {
        let label = UILabel()
        label.setLabel(text: "1", textColor: .gray700, font: .body14Bd)
        return label
    }()
    
    private let perLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "/", textColor: .gray500, font: .body14Md)
        return label
    }()
    
    private let totalPage: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray500, font: .body14Md)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StampBoardFooterView {
    private func setUI() {
        [currentPage, perLabel, totalPage].forEach {
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(with total: Int) {
        totalPage.text = "\(total)"
    }
}

extension StampBoardFooterView: FooterViewUpdatable {
    func updateCurrentCount(with count: Int) {
        guard let totalCountText = totalPage.text else { return }
        guard let totalCount = Int(totalCountText) else { return }
        
        if count <= totalCount {
            currentPage.text = "\(count)"
        }
    }
}
