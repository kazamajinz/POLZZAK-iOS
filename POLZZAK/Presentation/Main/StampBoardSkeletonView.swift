//
//  StampBoardSkeletonView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/24.
//

import UIKit
import SnapKit

final class StampBoardSkeletonView: BaseFilterSkeletonView {
    
    init(frame: CGRect = .zero) {
        super.init(frame: frame, constants: StampBoardSkeletonView.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StampBoardSkeletonView: SkeletonViewConstants {
    static var deviceWidth: CGFloat = UIApplication.shared.width
    static var deviceHeight: CGFloat = UIApplication.shared.height
    static var tabTitles: [String] = ["진행중", "완료"]
    
    static var headerViewHeight: CGFloat = 42.0
    
    static var filterViewTopSpacing: CGFloat = 21.0
    static var filterViewLeadingSpacing: CGFloat = 16.0
    static var filterViewBottomSpacing: CGFloat = 35.0
    static var filterViewWidth: CGFloat = 63.0
    static var filterViewHeight: CGFloat = 32.0
    
    static var cellCount: Int = 3
    static var cellContentsTopSpacing: CGFloat = 12.0
    static var cellSectionHorizontalSpacing: CGFloat = 26.0
    static var cellSectionVerticalSpacing: CGFloat = 32.0
    static var cellHeaderWidth: CGFloat = deviceWidth * 195.0 / 375.0
    static var cellHeaderHeight: CGFloat = 28.0
    static var cellContentsHeight: CGFloat = deviceHeight * 377.0 / 812.0
}
