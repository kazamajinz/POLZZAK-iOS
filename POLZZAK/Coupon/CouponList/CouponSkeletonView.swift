//
//  CouponSkeletonView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/16.
//

import UIKit
import SnapKit

final class CouponSkeletonView: UIView {
    private let deviceWidth = UIApplication.shared.width
    
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let tabViews: TabViews = {
        let tabViews = TabViews()
        tabViews.tabTitles = ["선물 전", "선물 완료"]
        tabViews.setTouchInteractionEnabled(false)
        return tabViews
    }()
    
    private let filterView = SkeletonCustomView()
    private let firstHeaderView = SkeletonCustomView()
    private let firstCellView = SkeletonCustomView()
    private let secondHeaderView = SkeletonCustomView()
    private let secondCellView = SkeletonCustomView()
    private let thirdHeaderView = SkeletonCustomView()
    private let thirdCellView = SkeletonCustomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(deviceWidth)
        }
        
        [headerView, filterView, firstHeaderView, firstCellView, secondHeaderView, secondCellView, thirdHeaderView, thirdCellView].forEach {
            contentsView.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        headerView.addSubview(tabViews)
        
        tabViews.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(tabViews.snp.bottom).offset(21)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(63)
            $0.height.equalTo(32)
        }
        
        firstHeaderView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom).offset(23)
            $0.leading.equalToSuperview().inset(26)
            $0.width.equalTo(195)
            $0.height.equalTo(28)
        }
        
        firstCellView.snp.makeConstraints {
            $0.top.equalTo(firstHeaderView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(180)
        }
        
        secondHeaderView.snp.makeConstraints {
            $0.top.equalTo(firstCellView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(26)
            $0.width.equalTo(195)
            $0.height.equalTo(28)
        }
        
        secondCellView.snp.makeConstraints {
            $0.top.equalTo(secondHeaderView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(180)
        }
        
        thirdHeaderView.snp.makeConstraints {
            $0.top.equalTo(secondCellView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(26)
            $0.width.equalTo(195)
            $0.height.equalTo(28)
        }
        
        thirdCellView.snp.makeConstraints {
            $0.top.bottom.equalTo(thirdHeaderView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
    }
    
    func showSkeletonView() {
        [filterView, firstHeaderView, firstCellView, secondHeaderView, secondCellView, thirdHeaderView, thirdCellView].forEach {
            $0.startShimmering()
        }
    }
    
    func hideSkeletonView() {
        [filterView, firstHeaderView, firstCellView, secondHeaderView, secondCellView, thirdHeaderView, thirdCellView].forEach {
            $0.stopShimmering()
        }
        isHidden = true
    }
}
