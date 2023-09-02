//
//  StampAllowBottomSheetViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/30.
//

import Combine
import Foundation
import UIKit

import CombineCocoa
import PanModal

final class StampAllowBottomSheetViewController: StampBasicBottomSheetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureBinding()
    }
    
    private func configureView() {
        setTitleLabel(text: "미션 직접 선택")
        setStepLabel(text: "1/2")
        setRightButton(text: "다음")
        setLeftButton(text: "닫기")
    }
    
    private func configureBinding() {
        setRightButtonTapAction { [weak self] in
            let vc = StampChoiceBottomSheetViewController()
            self?.navigationController?.pushViewController(vc, animated: false)
        }
        
        setLeftButtonTapAction {
            
        }
    }
    
    // MARK: - PanModalPresentable
    
    override var panScrollable: UIScrollView? {
        return nil
    }
    
    override var longFormHeight: PanModalHeight {
        return .contentHeight(UIApplication.shared.height * 0.85)
    }
}
