//
//  CustomRefreshControl.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/21.
//

import UIKit
import SnapKit

protocol CustomRefreshControlDelegate: AnyObject {
    func didFinishDragging()
}

class CustomRefreshControl: UIRefreshControl {
    
    //MARK: - Delegate
    weak var delegate: CustomRefreshControlDelegate?
    
    //MARK: - let, var
    private let initialContentOffsetY: Double = 74.0
    private let headerTabHeight: Double = 61.0
    private var isRefresh: Bool = false
    private var observation: NSKeyValueObservation?
    
    //MARK: - UI
    private let refreshImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.0
        imageView.image = UIImage(named: "refreshDragImage")
        return imageView
    }()
    
    private let refreshIndicator: UIActivityIndicatorView = {
        let refreshIndicator = UIActivityIndicatorView(style: .large)
        refreshIndicator.color = .blue300
        refreshIndicator.hidesWhenStopped = true
        return refreshIndicator
    }()
    
    // MARK: - Initialization
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
    
    // MARK: - Control Events
    override func beginRefreshing() {
        super.beginRefreshing()

        isRefresh = false
        refreshImageView.alpha = 0.0
        refreshIndicator.startAnimating()
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
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(topPadding)
        }
        
        refreshIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(topPadding)
        }
    }
    
    
    func observe(scrollView: UIScrollView) {
        observation = scrollView.observe(\.contentOffset, options: .new) { [weak self] scrollView, _ in
            guard let self = self else { return }
            let currentOffset = scrollView.contentOffset.y
            let distance = -(initialContentOffsetY + currentOffset)
            
            if distance > 0 {
                if false == refreshIndicator.isAnimating && true == isRefresh {
                    refreshImageView.alpha = min(distance, headerTabHeight) / headerTabHeight
                    if refreshImageView.alpha == 1 {
                        beginRefreshing()
                    }
                }
            } else if distance == 0 {
                isRefresh = true
            }
        }
    }
}
