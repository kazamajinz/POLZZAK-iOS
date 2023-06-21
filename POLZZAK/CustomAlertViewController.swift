//
//  CustomAlertViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit
import SnapKit

class CustomAlertViewController: UIViewController {
    private let customAlertView: CustomAlertView
    private let action: ((@escaping () -> Void) -> Void)?
    
    private let width = UIApplication.shared.width * 343.0 / 375.0
    private let height = UIApplication.shared.width * 343.0 / 375.0 * 196.0 / 343.0
    
    init(alertStyle: AlertStyleProtocol, action: ((@escaping () -> Void) -> Void)? = nil) {
        self.action = action
        self.customAlertView = CustomAlertView(alertStyle: alertStyle)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        view.addSubview(customAlertView)
        
        customAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        
        customAlertView.firstButtonAction = { [weak self] in
            self?.dismiss(animated: false)
        }
        
        customAlertView.secondButtonAction = { [weak self] in
            guard let self = self else { return }
            self.action? {
                self.dismiss(animated: false)
            }
        }
    }
    
}
