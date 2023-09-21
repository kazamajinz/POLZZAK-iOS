//
//  BaseAlertViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/19.
//

import UIKit
import SnapKit

class BaseAlertViewController: UIViewController {
    enum Constants {
        static let alertWidth = UIApplication.shared.width * 343.0 / 375.0
    }
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(Constants.alertWidth)
        }
    }
}

