//
//  FullScreenLoadingView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/22.
//

import UIKit
import SnapKit

final class FullScreenLoadingView: UIView {
    private let loadingView = LoadingView()

    init(frame: CGRect = .zero, style: LoadingViewStyle) {
        super.init(frame: frame)
        setupView(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(style: LoadingViewStyle) {
        backgroundColor = .white
        isHidden = true
        
        addSubview(loadingView)
        
        loadingView.snp.makeConstraints {
            let topConstraint = style.topConstraint
            $0.top.equalTo(topConstraint)
            $0.centerX.equalToSuperview()
        }
    }
    
    func startLoading() {
        loadingView.startRotating()
        isHidden = false
    }

    func stopLoading() {
        isHidden = true
    }
}
