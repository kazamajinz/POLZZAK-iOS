//
//  BaseFilterSkeletonView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/25.
//

import UIKit
import SnapKit

protocol SkeletonViewConstants {
    static var deviceWidth: CGFloat { get }
    static var deviceHeight: CGFloat { get }
    static var tabTitles: [String] { get }
    
    //MARK: - headerView
    static var headerViewHeight: CGFloat { get }
    
    //MARK: - filterView
    static var filterViewTopSpacing: CGFloat { get }
    static var filterViewLeadingSpacing: CGFloat { get }
    static var filterViewBottomSpacing: CGFloat { get }
    static var filterViewWidth: CGFloat { get }
    static var filterViewHeight: CGFloat { get }
    
    //MARK: - cell
    static var cellCount: Int { get }
    static var cellContentsTopSpacing: CGFloat { get }
    static var cellSectionHorizontalSpacing: CGFloat { get }
    static var cellSectionVerticalSpacing: CGFloat { get }
    static var cellHeaderWidth: CGFloat { get }
    static var cellHeaderHeight: CGFloat { get }
    static var cellContentsHeight: CGFloat { get }
}

class BaseFilterSkeletonView: UIView {
    var constants: SkeletonViewConstants.Type
    
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
    
    private let tabHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var tabViews: TabViews = {
        let tabViews = TabViews()
        tabViews.tabTitles = constants.tabTitles
        tabViews.setTouchInteractionEnabled(false)
        return tabViews
    }()
    
    private let filterView = SkeletonView()
    
    private lazy var headerViews: [SkeletonView] = {
        return (0..<constants.cellCount).map { _ in SkeletonView() }
    }()
    
    private lazy var cellViews: [SkeletonView] = {
        return (0..<constants.cellCount).map { _ in SkeletonView() }
    }()
    
    init(frame: CGRect, constants: SkeletonViewConstants.Type) {
            self.constants = constants
            super.init(frame: frame)
            setupUI()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(constants.deviceWidth)
        }
        
        ([tabHeaderView, filterView] + headerViews + cellViews).forEach {
            contentsView.addSubview($0)
        }
        
        tabHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(constants.headerViewHeight)
        }
        
        tabHeaderView.addSubview(tabViews)
        
        tabViews.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(tabViews.snp.bottom).offset(constants.filterViewTopSpacing)
            $0.leading.equalToSuperview().inset(constants.filterViewLeadingSpacing)
            $0.width.equalTo(constants.filterViewWidth)
            $0.height.equalTo(constants.filterViewHeight)
        }
        
        var lastView: UIView = filterView
        for (index, (headerView, cellView)) in zip(headerViews, cellViews).enumerated() {
            let topOffset = (index == 0) ? constants.filterViewBottomSpacing : constants.cellSectionVerticalSpacing
            setupView(headerView, below: lastView, topOffset: topOffset, isHeaderView: true)
            setupView(cellView, below: headerView, topOffset: constants.cellContentsTopSpacing, isHeaderView: false)
            lastView = cellView
        }
    }
    
    private func setupView(_ view: UIView, below lastView: UIView, topOffset: CGFloat, isHeaderView: Bool) {
        view.snp.makeConstraints {
            $0.top.equalTo(lastView.snp.bottom).offset(topOffset)
            $0.leading.equalToSuperview().inset(constants.cellSectionHorizontalSpacing)
            if true == isHeaderView {
                $0.width.equalTo(constants.cellHeaderWidth)
                $0.height.equalTo(constants.cellHeaderHeight)
            } else {
                $0.trailing.equalToSuperview().inset(constants.cellSectionHorizontalSpacing)
                $0.height.equalTo(constants.cellContentsHeight)
            }
        }
    }
    
    func showSkeletonView() {
        ([filterView] + headerViews + cellViews).forEach {
            $0.startShimmering()
        }
    }
    
    func hideSkeletonView() {
        ([filterView] + headerViews + cellViews).forEach {
            $0.stopShimmering()
        }
        isHidden = true
    }
}
