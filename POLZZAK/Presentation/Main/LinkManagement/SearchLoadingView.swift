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
        label.textColor = .gray800
        label.font = .body14Md
        label.textAlignment = .center
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .caption12Bd
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
        placeholder.text = "\(nickName)님을\n열심히 찾는 중이에요"
        let emphasisRange = [NSRange(location: 0, length: nickName.count)]
        placeholder.setEmphasisRanges(emphasisRange, color: .gray800, font: .body14Bd)
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
