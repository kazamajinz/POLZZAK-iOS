//
//  StampAllowNavigationController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/31.
//

import UIKit

import PanModal

final class StampAllowNavigationController: UINavigationController, PanModalPresentable {
    init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [StampAllowBottomSheetViewController()]
        view.backgroundColor = .white
        isNavigationBarHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        panModalSetNeedsLayoutUpdate()
        /// 아래에서 애니메이션 동작을 하지 않아서
        /// performWithoutAnimation으로 일단 해놓았음
        UIView.performWithoutAnimation {
            panModalTransition(to: .longForm)
        }
        return vc
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        panModalSetNeedsLayoutUpdate()
        /// 이 때 애니메이션 동작을 하지 않아서
        /// performWithoutAnimation으로 일단 해놓았음
        UIView.performWithoutAnimation {
            panModalTransition(to: .longForm)
        }
    }
    
    // MARK: - Pan Modal Presentable
    
    var panScrollable: UIScrollView? {
        return (topViewController as? PanModalPresentable)?.panScrollable
    }
    
    var longFormHeight: PanModalHeight {
        guard let topViewController = topViewController as? PanModalPresentable else {
            return .contentHeight(UIApplication.shared.height * 0.85)
        }
        return topViewController.longFormHeight
    }
    
    var dragIndicatorBackgroundColor: UIColor {
        return .gray200
    }
    
    var cornerRadius: CGFloat {
        return 12
    }
    
    var anchorModalToLongForm: Bool {
        return true /// false로주면 애니메이션은 동작하지만 컨텐츠가 원하는대로 되지 않음
    }
    
    var allowsTapToDismiss: Bool {
        return false
    }
}
