//
//  CouponGuideViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/06.
//

import UIKit
import SnapKit

final class CouponGuideViewController: UIViewController {
    private let deviceWidth = UIApplication.shared.width
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadious(cornerRadius: 12)
        view.layer.masksToBounds = true
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
//    private let topTilte: UIButton = {
//        let button = UIButton()
//        button.setImage(.acceptButton, for: .normal)
//        button.setTitleLabel(title: "‘선물 전’ 쿠폰은 무엇인가요?", color: .gray700, font: .subtitle16Bd)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
//        return button
//    }()
    private let topTilte: UIButton = {
        let button = UIButton()
        
        // Configuration 설정
        var config = UIButton.Configuration.filled()
        config.title = "‘선물 전’ 쿠폰은 무엇인가요?"
        config.image = UIImage(named: "acceptButton")
        config.imagePadding = 8
        config.imagePlacement = .leading
        
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray700,
                .font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ]
            
        let attributedString = NSAttributedString(string: config.title ?? "", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        
        button.configuration = config
        
        // 추가적인 스타일 설정 (색상 및 폰트)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let topContent: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setLabel(text: "도장판을 다 모아서 받은 선물 쿠폰에 대해, 보호자가 아직 실제로 선물을 전달하지 않은 쿠폰입니다.",textColor: .gray600, font: .subtitle1)
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitleLabel(title: "이해됐어요", color: .white, font: .subtitle16Sbd, backgroundColor: .blue500)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .overCurrentContext
        
        setUI()
        confirmButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CouponGuideViewController {
    private func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(deviceWidth * 426.0 / 343.0)
        }
        
        [topTilte, topContent].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        [topStackView, confirmButton].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.bottom.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}
