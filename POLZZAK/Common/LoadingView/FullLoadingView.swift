//
//  FullLoadingView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/14.
//

import UIKit
import SnapKit

final class FullLoadingView: UIView {
    private let loadingView = LoadingView()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        isHidden = true
        
        addSubview(loadingView)
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func startLoading() {
        isHidden = false
//        loadingView.startRotating()
    }

    func stopLoading() {
        isHidden = true
//        loadingView.s()
    }
}
