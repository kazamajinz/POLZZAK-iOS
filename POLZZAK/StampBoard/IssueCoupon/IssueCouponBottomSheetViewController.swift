//
//  IssueCouponBottomSheetViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/06.
//

import Combine
import UIKit

import CombineCocoa
import PanModal

class IssueCouponBottomSheetViewController: UIViewController {
    private enum Constants {
        static let basicInset: CGFloat = 16
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue600
        label.font = .subtitle18Sbd
        label.text = "2023 콘서트 티켓"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray800
        label.font = .subtitle16Sbd
        label.text = "쿠폰이 활성화 되었어요!"
        return label
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let couponImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue200
        imageView.image = UIImage(named: "coupon")
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .caption12Md
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "언제까지 선물을 주실 예정인가요?\n선물 예정일은 수정이 불가하니 신중하게 정해주세요."
        return label
    }()
    
    private let dueContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.borderColor = UIColor.gray200.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let dueDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .body14Md
        label.textAlignment = .left
        label.text = "선물 예정일"
        return label
    }()
    
    private let dueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray800
        label.font = .body14Md
        label.textAlignment = .right
        label.text = "날짜를 설정해주세요"
        return label
    }()
    
    private let dueCalenderButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "issue_stamp_calender")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let issueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue500
        button.layer.cornerRadius = 8
        let title = NSAttributedString(
            string: "쿠폰 발급하기",
            attributes: [
            .font: UIFont.subtitle16Sbd,
            .foregroundColor: UIColor.white
        ])
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureLayout() {
        [titleLabel, subtitleLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        [labelStackView].forEach {
            view.addSubview($0)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

//        labelStackView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(10)
//            make.centerX.equalToSuperview()
//        }
//
//        contentView.snp.makeConstraints { make in
//            make.top.equalTo(labelStackView.snp.bottom).offset(10)
//            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
//            make.bottom.equalTo(buttonStackView.snp.top).offset(-10)
//        }
//
//        buttonStackView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(Constants.basicInset)
//            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
//            make.height.equalTo(50)
//        }
    }
}

// MARK: - PanModalPresentable

extension IssueCouponBottomSheetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .intrinsicHeight
    }
}
