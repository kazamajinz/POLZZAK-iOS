//
//  CustomRefreshControl.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/21.
//

import UIKit
import SnapKit

class CustomRefreshControl: UIRefreshControl {
    var isRefresh: Bool = true
    var isStartRefresh: Bool = false
    var initialContentOffsetY: Double = 0.0
    private var lastContentOffset: CGFloat = 0
    private var initialOffset: CGFloat?
    private var refreshImageViewTopConstraint: Constraint?
    private var refreshIndicatorTopConstraint: Constraint?
    
    private var observation: NSKeyValueObservation?
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
}

extension CustomRefreshControl {
    private func setupUI(topPadding: CGFloat) {
        tintColor = .clear
        
        [refreshImageView, refreshIndicator].forEach {
            addSubview($0)
        }
        
        refreshImageView.snp.makeConstraints {
            refreshImageViewTopConstraint = $0.centerY.equalToSuperview().offset(topPadding).constraint
            $0.centerX.equalToSuperview()
        }
        
        refreshIndicator.snp.makeConstraints {
            refreshIndicatorTopConstraint = $0.centerY.equalToSuperview().offset(topPadding).constraint
            $0.centerX.equalToSuperview()
        }
    }
    
    func observe(scrollView: UIScrollView) {
        observation = scrollView.observe(\.contentOffset, options: .new) { [weak self] scrollView, _ in
            guard let self = self else { return }
            guard true == isStartRefresh else { return }
            
            let yOffset = scrollView.contentOffset.y
            let scrollingUp = scrollView.contentOffset.y > self.lastContentOffset
            
            if yOffset < 0 {
                self.refreshImageView.transform = CGAffineTransform(translationX: 0, y: -yOffset/3)
                self.refreshIndicator.transform = CGAffineTransform(translationX: 0, y: -yOffset/3)
            } else {
                self.refreshImageView.transform = .identity
                self.refreshIndicator.transform = .identity
            }
            
            let maxHeight = 60.0
            let currentOffset = -(yOffset + initialContentOffsetY)
            
            if false == refreshIndicator.isAnimating {
                if false == isRefresh {
                    if scrollingUp {
                        self.refreshImageView.alpha = 0
                    } else {
                        refreshImageView.alpha = currentOffset / maxHeight
                    }
                    if currentOffset > maxHeight {
                        triggerRefresh()
                        isStartRefresh = false
                    }
                } else {
                    if currentOffset <= initialContentOffsetY - 10.0 {
                        isRefresh = false
                    }
                }
            } else {
                if currentOffset == 0.0 {
                    refreshIndicator.stopAnimating()
                }
            }
            
            self.lastContentOffset = scrollView.contentOffset.y
        }
    }
    
    func updateTopPadding(to newValue: CGFloat) {
        refreshImageViewTopConstraint?.update(offset: newValue)
        refreshIndicatorTopConstraint?.update(offset: newValue)
    }
    
    private func triggerRefresh() {
        isRefresh = true
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
}
