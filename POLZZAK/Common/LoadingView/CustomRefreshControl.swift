//
//  CustomRefreshControl.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/21.
//

import UIKit
import SnapKit

final class CustomRefreshControl: UIRefreshControl {
    var isRefresh: Bool = true
    private let initialContentOffsetY: Double = 74.0
    private let headerTabHeight: Double = 61.0
    private var observation: NSKeyValueObservation?
    private var initialOffset: CGFloat?
    
    private let refreshImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.0
        imageView.image = UIImage(named: "refreshDragImage")
        return imageView
    }()
    
    private let refreshIndicator: UIActivityIndicatorView = {
        let refreshIndicator = UIActivityIndicatorView(style: .large)
        refreshIndicator.color = .blue400
        refreshIndicator.hidesWhenStopped = true
        refreshIndicator.isHidden = true
        refreshIndicator.stopAnimating()
        return refreshIndicator
    }()
    
    init(topPadding: CGFloat = 0.0) {
        super.init()
        setupUI(topPadding: topPadding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        observation?.invalidate()
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshImageView.alpha = 0
        refreshIndicator.startAnimating()
        isRefresh = true
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshIndicator.stopAnimating()
    }
}

extension CustomRefreshControl {
    private func setupUI(topPadding: CGFloat = 0) {
        tintColor = .clear
        
        [refreshImageView, refreshIndicator].forEach {
            addSubview($0)
        }
        
        refreshImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        refreshIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func observe(scrollView: UIScrollView) {
        observation = scrollView.observe(\.contentOffset, options: .new) { [weak self] scrollView, _ in
            guard let self = self else { return }
            let currentOffset = scrollView.contentOffset.y
            let distance = -(initialContentOffsetY + currentOffset)
            
            if false == refreshIndicator.isAnimating {
                if false == isRefresh {
                    refreshImageView.alpha = distance / headerTabHeight
                    if distance > headerTabHeight {
                        triggerRefresh()
                    }
                } else {
                    if 0 == distance {
                        isRefresh = false
                    }
                }
            }
        }
    }
    
    private func triggerRefresh() {
        isRefresh = true
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
}
