//
//  SearchLoadingView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/20.
//

import UIKit
import SnapKit

final class SearchLoadingView: UIView {
    private let loadingView = LoadingView()
    private let placeholder: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .caption3
        button.backgroundColor = .blue500
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nickName: String) {
        let emphasisRangeArray = [NSRange(location: 0, length: nickName.count)]
        let builder = LabelStyleBuilder()
        let style = builder.setText("\(nickName)님을\n열심히 찾는 중이에요")
            .setTextColor(.gray800)
            .setFont(.body3)
            .setTextAlignment(.center)
            .setEmphasisRangeArray(emphasisRangeArray)
            .setEmphasisColor(.gray800)
            .setEmphasisFont(.body5)
            .build()
        placeholder.setLabel(style: style)
    }
    
    private func setUI() {
        backgroundColor = .white
        
        [loadingView, placeholder, cancelButton].forEach {
            addSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(182)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        placeholder.snp.makeConstraints {
            $0.top.equalTo(loadingView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(placeholder.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(93)
            $0.height.equalTo(32)
        }
    }
}
