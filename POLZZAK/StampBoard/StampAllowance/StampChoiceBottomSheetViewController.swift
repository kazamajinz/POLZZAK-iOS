//
//  StampChoiceBottomSheetViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/30.
//

import Combine
import Foundation
import UIKit

import CombineCocoa
import PanModal

final class StampChoiceBottomSheetViewController: StampBasicBottomSheetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureBinding()
    }
    
    private func configureView() {
        setTitleLabel(text: "도장 선택")
        setStepLabel(text: "2/2")
        setRightButton(text: "도장 찍기")
        setLeftButton(text: "이전")
    }
    
    private func configureBinding() {
        setRightButtonTapAction { [weak self] in
            
        }
        
        setLeftButtonTapAction { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK: - PanModalPresentable
    
    override var panScrollable: UIScrollView? {
        return nil
    }
    
    override var longFormHeight: PanModalHeight {
        return .contentHeight(UIApplication.shared.height * 0.7)
    }
}
