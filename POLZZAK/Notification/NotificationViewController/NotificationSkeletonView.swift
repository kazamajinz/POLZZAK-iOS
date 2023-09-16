//
//  NotificationSkeletonView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import UIKit
import SnapKit

final class NotificationSkeletonView: UIView {
    enum Constants {
        static let deviceWidth: CGFloat = UIApplication.shared.width
        static var deviceHeight: CGFloat = UIApplication.shared.height
        static let cellCount: Int = 5
        static var cellContentsHeight: CGFloat = deviceHeight * 149.0 / 812.0
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .vertical, spacing: 8.0)
        return stackView
    }()
    
    
    private lazy var cellViews: [SkeletonView] = {
        return (0..<Constants.cellCount).map { _ in SkeletonView() }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NotificationSkeletonView {
    private func setupUI() {
        
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(Constants.deviceWidth)
        }
        
        contentsView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        for cellView in cellViews {
            stackView.addArrangedSubview(cellView)
            cellView.snp.makeConstraints {
                $0.height.equalTo(Constants.cellContentsHeight)
            }
        }
    }
    
    func showSkeletonView() {
        cellViews.forEach {
            $0.startShimmering()
        }
    }
    
    func hideSkeletonView() {
        cellViews.forEach {
            $0.stopShimmering()
        }
        isHidden = true
    }

}
